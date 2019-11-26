require 'jwt'
require 'google/apis/people_v1'
require 'json'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_filter :verify_authenticity_token, :only => [:google, :google_oauth2]

  def google
    raise "Obsolete google openid not supported"
  end

  def google_oauth2
    begin
      primary_email = ""
      alternate_emails = []
      username_domain = CfiOauthProvider::Application.config.get_username_from_domain
      username = nil

      people = Google::Apis::PeopleV1::PeopleServiceService.new
      people.authorization = request.env['omniauth.auth']['credentials']['token']
      p = people.get_person('people/me', person_fields: 'names,emailAddresses')
      p.email_addresses.each do |e|
        if not e.metadata.verified
          next
        end

        if username_domain
          m = /^(.*)@#{username_domain}$/.match(e.value)
          if m
            username = m[1]
          end
        end

        if e.metadata.primary
          primary_email = e.value
        else
          alternate_emails << e.value
        end
      end

      begin
        @user = User.authenticate(:google_oauth2,
                                  primary_email,
                                  request.env['omniauth.auth']['uid'],
                                  current_user,
                                  username: username)
      rescue User::EmailCollision => e
        if openid_id = JWT.decode(request.env['omniauth.auth']['extra']['id_token']).payload[:openid_id]
          # Try OpenId
          @user = User.authenticate(:google,
                                    primary_email,
                                    openid_id,
                                    current_user)
          # Create authentication record for OAuth2
          auth = Authentication.new
          auth.user_id = @user.id
          auth.provider = :google_oauth2
          auth.uid = request.env['omniauth.auth']['uid']
          auth.save!
        else
          raise
        end
      end

      @user.alternate_emails = JSON.generate(alternate_emails)

      do_sign_in
    rescue => e
      logger.warn e.backtrace
      @error = e
      render 'failure', status: :forbidden
    end
  end

  def ldap
    ldap_conf = CfiOauthProvider::Application.config.use_ldap
    info = request.env['omniauth.auth']['info']

    if !info['email'].nil? and !info['email'].empty?
      email = request.env['omniauth.auth']['info']['email']
    elsif !ldap_conf["email_domain"].nil? and !ldap_conf["email_domain"].empty?
      email = info['nickname'] + "@" + ldap_conf["email_domain"]
    else
      render 'failure', status: :forbidden
      return
    end

    username = if ldap_conf['username']
                 request.env['omniauth.auth']['extra']['raw_info'][ldap_conf['username'].to_sym][0]
               end

    begin
      @user = User.authenticate(:ldap,
                                email,
                                request.env['omniauth.auth']['uid'],
                                current_user,
                                username: username)
      do_sign_in "LDAP"
    rescue => e
      logger.warn e.backtrace
      @error = e
      render 'failure', status: :forbidden
    end
  end

  protected

  def do_sign_in(kind="Google")
    @user.first_name = request.env['omniauth.auth']['info']['first_name'] || request.env['omniauth.auth']['info']['name']
    @user.last_name = request.env['omniauth.auth']['info']['last_name']
    @user.save

    current_user = @user

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => kind
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
