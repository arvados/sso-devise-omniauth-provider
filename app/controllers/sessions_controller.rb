class SessionsController < Devise::SessionsController
  def new
    resource = build_resource
    clean_up_passwords(resource)
    if User.omniauth_providers.empty? then
      respond_with(resource, serialize_options(resource))
    else
      if session[:auth_provider]
        redirect_to "/users/auth/#{session[:auth_provider]}"
      else
        redirect_to "/users/auth/#{User.omniauth_providers.first}"
      end
    end
  end

  def create
    begin
      puts "starting #{auth_options}"
      self.resource = warden.authenticate!(auth_options)
      set_flash_message(:notice, :signed_in) if is_flashing_format?
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    rescue => e
    end
  end
end
