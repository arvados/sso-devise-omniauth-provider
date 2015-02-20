class User < ActiveRecord::Base
  has_many :authentications, :dependent => :delete_all
  has_many :access_grants, :dependent => :delete_all

  class EmailCollision < StandardError
  end

  before_validation :initialize_fields, :on => :create

  devise :token_authenticatable, :database_authenticatable

  if CfiOauthProvider::Application.config.google_deprecated_openid
    devise :omniauthable, :omniauth_providers => [:google, :google_oauth2]
  else
    devise :omniauthable, :omniauth_providers => [:google_oauth2]
  end

  attr_accessible :email, :remember_me, :first_name, :last_name

  def self.authenticate(provider, email, uid, signed_in_resource=nil)
    if auth = Authentication.where(:provider => provider.to_s, :uid => uid.to_s).first
      User.find(auth.user_id)
    elsif user = User.where(:email => email).first
      # User record exists, but don't have any information for this provider
      raise EmailCollision.new
    else
      # New user
      user = User.new(:email => email)
      user.password = Devise.friendly_token[0,20]
      user.uuid = [CfiOauthProvider::Application.config.uuid_prefix,
                   'tpzed',
                   rand(2**256).to_s(36)[-15..-1]].
                  join '-'
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
  end
end
