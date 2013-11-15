class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_filter :verify_authenticity_token, :only => :google

  def google
    @user = User.find_for_open_id(request.env["omniauth.auth"], current_user)

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
