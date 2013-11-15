class SessionsController < Devise::SessionsController

  # If we have a redirect_to url, which means
  # that an application is trying to authenticate via this service,
  # send the user directly to Google's openid login page.
  #
  # If not, which means that someone hit the /users/sign_in page directly,
  # just show that page.
  def new
    resource = build_resource
    clean_up_passwords(resource)
    if session[:user_return_to].nil? or session[:user_return_to].match('^/auth/').nil? then
      respond_with(resource, serialize_options(resource))
    else
      redirect_to '/users/auth/google'
    end
  end

end

