class AuthController < ApplicationController
  before_filter :save_auth_provider
  before_filter :authenticate_user!, :except => [:access_token]
  skip_before_filter :verify_authenticity_token, :only => [:access_token]

  def save_auth_provider
    session[:auth_provider] = params[:auth_provider]
  end

  def authorize
    AccessGrant.prune!
    access_grant = current_user.access_grants.create({:client => application, :state => params[:state]}, :without_protection => true)
    redirect_to access_grant.redirect_uri_for(params[:redirect_uri],params[:state])
  end

  def access_token
    application = Client.authenticate(params[:client_id], params[:client_secret])

    if application.nil?
      render :json => {:error => "Could not authenticate application with client id: #{params[:client_id]}"}
      return
    end

    access_grant = AccessGrant.authenticate(params[:code], application.id)
    if access_grant.nil?
      render :json => {:error => "Could not authenticate access code"}
      return
    end

    access_grant.start_expiry_period!
    render :json => {:access_token => access_grant.access_token, :refresh_token => access_grant.refresh_token, :expires_in => Devise.timeout_in.to_i}
  end

  def failure
    render :text => "ERROR: #{params[:message]}"
  end

  def user
    hash = {
      :provider => 'josh_id',
      :id => current_user.uuid,
      :info => {
         :email      => current_user.email,
         :first_name => current_user.first_name,
         :last_name  => current_user.last_name,

         # If there is a legacy OpenId 2.0 identity, provide that in identity_url.
         # Otherwise, provide the newly allocated uuid for identity_url.
         :identity_url => (
           if u = Authentication.where(:provider => "google",
                                       :user_id => current_user.id).first
           then
             u.uid
           else
             current_user.uuid
           end)
      }
    }

    render :json => hash.to_json
  end

  # Incase, we need to check timeout of the session from a different application!
  # This will be called ONLY if the user is authenticated and token is valid
  # Extend the UserManager session
  def isalive
    warden.set_user(current_user, :scope => :user)
    response = { 'status' => 'ok' }

    respond_to do |format|
      format.any { render :json => response.to_json }
    end
  end

  protected

  def application
    @application ||= Client.find_by_app_id(params[:client_id])
  end

end
