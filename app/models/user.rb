class User < ActiveRecord::Base
  has_many :authentications, :dependent => :delete_all
  has_many :access_grants, :dependent => :delete_all

  before_validation :initialize_fields, :on => :create

  devise :token_authenticatable, :database_authenticatable

  devise :omniauthable, :omniauth_providers => [:google, :google_oauth2]

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name

  def self.find_for_identity(email, identity_url, signed_in_resource=nil)
    if user = User.where(:identity_url => identity_url).first
      # We found the user record by means of the identity_url, all is good
      user
    elsif user = User.where(:email => email).first
      # User record exists, but the identity_url does not match
      # This is fishy. Politely decline access.
      raise "Identity_url mismatch"
    else
      # New user
      # identity_url is deliberately not in attr_accessible to avoid shenanigans, so assign
      # it explicitly. Ward, 2012-08-29
      user = User.new(:email => email, :password => Devise.friendly_token[0,20])
      user.identity_url = identity_url
      user.save!
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
