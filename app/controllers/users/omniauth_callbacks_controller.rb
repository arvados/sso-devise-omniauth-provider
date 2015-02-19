require 'jwt'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_filter :verify_authenticity_token, :only => [:google, :google_oauth2]

  def google
    begin
    @user = User.find_for_identity(request.env['omniauth.auth']['info']['email'],
                                   request.env['omniauth.auth']['uid'],
                                   current_user)
    do_sign_in
    rescue => e
      @error = e
      render 'failure', status: :forbidden
    end
  end

  def google_oauth2
    if JWT.decode(request.env['omniauth.auth']['extra']['id_token']).payload[:openid_id]
      # Victory!
    end

    google
  end

  protected

  def do_sign_in
    @user.first_name = request.env['omniauth.auth']['info']['first_name']
    @user.last_name = request.env['omniauth.auth']['info']['last_name']
    @user.save

    current_user = @user

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
