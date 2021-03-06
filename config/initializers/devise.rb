require_relative 'load_config.rb'

# Use this hook to configure devise mailer, warden hooks and so forth. The first
# four configuration values can also be set straight in your models.
Devise.setup do |config|
  # ==> Mailer Configuration
  # Configure the e-mail address which will be shown in DeviseMailer.
  config.mailer_sender = "please-change-me@config-initializers-devise.com"

  # Configure the class responsible to send e-mails.
  config.mailer = "Devise::Mailer"

  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require 'devise/orm/active_record'

  # ==> Configuration for any authentication mechanism
  # Configure which keys are used when authenticating an user. By default is
  # just :email. You can configure it to use [:username, :subdomain], so for
  # authenticating an user, both parameters are required. Remember that those
  # parameters are used only when authenticating and not when retrieving from
  # session. If you need permissions, you should implement that in a before filter.
  # You can also supply hash where the value is a boolean expliciting if authentication
  # should be aborted or not if the value is not present. By default is empty.
  # config.authentication_keys = [ :username ]

  # Configure parameters from the request object used for authentication. Each entry
  # given should be a request method and it will automatically be passed to
  # find_for_authentication method and considered in your model lookup. For instance,
  # if you set :request_keys to [:subdomain], :subdomain will be used on authentication.
  # The same considerations mentioned for authentication_keys also apply to request_keys.
  # config.request_keys = []

  # Tell if authentication through request.params is enabled. True by default.
  # config.params_authenticatable = true

  # Tell if authentication through HTTP Basic Auth is enabled. False by default.
  # config.http_authenticatable = false

  # If http headers should be returned for AJAX requests. True by default.
  # config.http_authenticatable_on_xhr = true

  # The realm used in Http Basic Authentication. "Application" by default.
  # config.http_authentication_realm = "Application"

  # ==> Configuration for :database_authenticatable
  # For bcrypt, this is the cost for hashing the password and defaults to 10. If
  # using other encryptors, it sets how many times you want the password re-encrypted.
  config.stretches = 10

  # ==> Configuration for :confirmable
  # The time you want to give your user to confirm his account. During this time
  # he will be able to access your application without confirming. Default is nil.
  # When confirm_within is zero, the user won't be able to sign in without confirming.
  # You can use this to let your user access some features of your application
  # without confirming the account, but blocking it after a certain period
  # (ie 2 days).
  # config.confirm_within = 2.days

  # ==> Configuration for :rememberable
  # The time the user will be remembered without asking for credentials again.
  # config.remember_for = 2.weeks

  # If true, a valid remember token can be re-used between multiple browsers.
  # config.remember_across_browsers = true

  # If true, extends the user's remember period when remembered via cookie.
  # config.extend_remember_period = false

  # If true, uses the password salt as remember token. This should be turned
  # to false if you are not using database authenticatable.
  # config.use_salt_as_remember_token = true

  # ==> Configuration for :validatable
  # Range for password length. Default is 6..20.
  # config.password_length = 6..20
  config.password_length = 10..20

  # Regex to use to validate the email address
  # config.email_regexp = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i

  # ==> Configuration for :timeoutable
  # The time you want to timeout the user session without activity. After this
  # time the user will be asked for credentials again. Default is 30 minutes.
  config.timeout_in = 1.minutes

  # ==> Configuration for :lockable
  # Defines which strategy will be used to lock an account.
  # :failed_attempts = Locks an account after a number of failed attempts to sign in.
  # :none            = No lock strategy. You should handle locking by yourself.
  # config.lock_strategy = :failed_attempts

  # Defines which strategy will be used to unlock an account.
  # :email = Sends an unlock link to the user email
  # :time  = Re-enables login after a certain amount of time (see :unlock_in below)
  # :both  = Enables both strategies
  # :none  = No unlock strategy. You should handle unlocking by yourself.
  # config.unlock_strategy = :both

  # Number of authentication tries before locking an account if lock_strategy
  # is failed attempts.
  # config.maximum_attempts = 20

  # Time interval to unlock the account if :time is enabled as unlock_strategy.
  # config.unlock_in = 1.hour

  # ==> Configuration for :encryptable
  # Allow you to use another encryption algorithm besides bcrypt (default). You can use
  # :sha1, :sha512 or encryptors from others authentication tools as :clearance_sha1,
  # :authlogic_sha512 (then you should set stretches above to 20 for default behavior)
  # and :restful_authentication_sha1 (then you should set stretches to 10, and copy
  # REST_AUTH_SITE_KEY to pepper)
  # config.encryptor = :sha512

  # Setup a pepper to generate the encrypted password.
  config.pepper = "aaae3bba030d00f7d0fe31efe059a7c65300f2b66a9e9caaa9073cdf7516c625a6e82380cc40a1648ac80baef4d61eb62cc555916414279bbf40a2e2a79b68cb"

  # ==> Configuration for :token_authenticatable
  # Defines name of the authentication token params key
  # config.token_authentication_key = :auth_token

  # If true, authentication through token does not store user in session and needs
  # to be supplied on each request. Useful if you are using the token as API token.
  # config.stateless_token = false

  # ==> Scopes configuration
  # Turn scoped views on. Before rendering "sessions/new", it will first check for
  # "users/sessions/new". It's turned off by default because it's slower if you
  # are using only default views.
  # config.scoped_views = false

  # Configure the default scope given to Warden. By default it's the first
  # devise role declared in your routes (usually :user).
  # config.default_scope = :user

  # Configure sign_out behavior.
  # Sign_out action can be scoped (i.e. /users/sign_out affects only :user scope).
  # The default is true, which means any logout action will sign out all active scopes.
  # config.sign_out_all_scopes = true

  # ==> Navigation configuration
  # Lists the formats that should be treated as navigational. Formats like
  # :html, should redirect to the sign in page when the user does not have
  # access, but formats like :xml or :json, should return 401.
  # If you have any extra navigational formats, like :iphone or :mobile, you
  # should add them to the navigational formats lists. Default is [:html]
  # config.navigational_formats = [:html, :iphone]

  # The default HTTP method used to sign out a resource. Default is :get.
  # config.sign_out_via = :get

  # ==> OAuth2
  # Add a new OAuth2 provider. Check the README for more information on setting
  # up on your models and hooks. By default this is not set.
  # config.oauth :github, 'APP_ID', 'APP_SECRET',
  #   :site              => 'https://github.com/',
  #   :authorize_path    => '/login/oauth/authorize',
  #   :access_token_path => '/login/oauth/access_token',
  #   :scope             => %w(user public_repo)

  # ==> Warden configuration
  # If you want to use other strategies, that are not supported by Devise, or
  # change the failure app, you can configure them inside the config.warden block.
  #
  # config.warden do |manager|
  #   manager.failure_app = AnotherApp
  #   manager.default_strategies(:scope => :user).unshift :some_external_strategy
  # end

  #config.warden do |manager|
    #manager.default_strategies(:scope => :user).unshift(:custom_database_authenticatable)
  #end

  # Google is phasing out OpenId 2.0, but some Arvados installations still rely on it.
  if CfiOauthProvider::Application.config.google_deprecated_openid
    require 'openid/store/filesystem'
    require 'rack/openid'

    # Monkey patch rack-openid gem: https://developers.google.com/accounts/docs/OpenID
    module Rack
      class OpenID
        private
        alias old_open_id_redirect_url open_id_redirect_url
        def open_id_redirect_url(req, oidreq, trust_root, return_to, method, immediate)
          old_open_id_redirect_url(req, oidreq, trust_root, return_to, method, immediate) + "&openid_shutdown_ack=2015-04-20"
        end
      end
    end
    config.omniauth :open_id, :store => OpenID::Store::Filesystem.new('./tmp_omniauth'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id', :require => 'omniauth-openid'
  end

  # Google OAuth2 / OpenId Connect support
  # See config/environments/(development, production, test).rb.example.rb

  opts = {:access_type => "online", :scope => "email profile user.emails.read"}
  if CfiOauthProvider::Application.config.google_openid_realm
    opts[:authorize_params] = {"openid.realm" => CfiOauthProvider::Application.config.google_openid_realm }
  end

  if CfiOauthProvider::Application.config.google_oauth2_client_id
    config.omniauth :google_oauth2,
                    CfiOauthProvider::Application.config.google_oauth2_client_id,
                    CfiOauthProvider::Application.config.google_oauth2_client_secret,
                    opts
  end

  if CfiOauthProvider::Application.config.use_ldap
    ldap_conf = CfiOauthProvider::Application.config.use_ldap

    if ldap_conf["email_domain"].nil? or ldap_conf["email_domain"].empty?
      # No email_domain defined, so do not strip anything from provided login
      name_proc = Proc.new {|name| name}
    else
      # Strip email_domain from user provided login
      name_proc = Proc.new {|name| name.gsub(/@#{ldap_conf["email_domain"]}$/,'')}
    end

    config.omniauth :ldap, {
                      :title        => ldap_conf["title"],
                      :host         => ldap_conf["host"],
                      :port         => ldap_conf["port"],
                      :method       => ldap_conf["method"].to_sym,
                      :base         => ldap_conf["base"],
                      :uid          => ldap_conf["uid"],
                      :email_domain => ldap_conf["email_domain"],
                      :name_proc    => name_proc,
                      :bind_dn      => ldap_conf["bind_dn"],
                      :password     => ldap_conf["password"]
                    }

  end

end
