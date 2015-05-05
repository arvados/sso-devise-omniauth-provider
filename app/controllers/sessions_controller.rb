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
      self.resource = warden.authenticate!(auth_options)
      redirect_to :root
    rescue => e
      puts "#{e}"
      redirect_to :root
    end
  end
end
