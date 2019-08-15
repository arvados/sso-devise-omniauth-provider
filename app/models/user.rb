require 'ldap'

class User < ActiveRecord::Base
  has_many :authentications, :dependent => :delete_all
  has_many :access_grants, :dependent => :delete_all

  class EmailCollision < StandardError
  end

  before_validation :initialize_fields, :on => :create

  devise :token_authenticatable, :database_authenticatable, :timeoutable
  if CfiOauthProvider::Application.config.allow_account_registration
    devise :registerable
    if CfiOauthProvider::Application.config.require_email_confirmation
      devise :confirmable
    end
  end

  providers = []
  providers << :local if CfiOauthProvider::Application.config.allow_account_registration
  providers << :ldap if CfiOauthProvider::Application.config.use_ldap
  providers << :google_oauth2 if CfiOauthProvider::Application.config.google_oauth2_client_id

  devise :omniauthable, :omniauth_providers => providers

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name

  # Executed after callback from external authentication source,
  # not for locally authenticated users
  def self.authenticate(provider, email, uid, signed_in_resource=nil, username: nil)
    if auth = Authentication.where(:provider => provider.to_s, :uid => uid.to_s).first
      User.find(auth.user_id)
    else
      # No match, create a new user and authentication object
      user = User.new(:email => email)
      user.username = username
      user.save!
      auth = Authentication.new
      auth.user_id = user.id
      auth.provider = provider
      auth.uid = uid
      auth.save!

      user
    end
  end

  self.token_authentication_key = "oauth_token"

  def apply_omniauth(omniauth)
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def self.find_for_token_authentication(conditions)
    where(["access_grants.access_token = ? AND (access_grants.access_token_expires_at IS NULL OR access_grants.access_token_expires_at > ?)", conditions[token_authentication_key], Time.now]).joins(:access_grants).select("users.*").first
  end

  def initialize_fields
    self.status = "Active"
    self.expiration_date = 1.year.from_now
    self.uuid = [CfiOauthProvider::Application.config.uuid_prefix,
                 'tpzed',
                 rand(2**256).to_s(36)[-15..-1]].
                join '-'
  end
end
