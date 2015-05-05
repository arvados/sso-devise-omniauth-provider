class RegistrationsController < Devise::RegistrationsController
  def new
     # Building the resource with information that MAY BE available from omniauth!
     build_resource(:first_name => session[:omniauth] && session[:omniauth]['user_info'] && session[:omniauth]['user_info']['first_name'],
         :last_name => session[:omniauth] && session[:omniauth]['user_info'] && session[:omniauth]['user_info']['last_name'],
         :email => session[:omniauth_email] )
     render :new
  end

  def create
    build_resource

    if session[:omniauth] && @user.errors[:email][0] =~ /has already been taken/
      user = User.find_by_email(@user.email)
      # Link Accounts - if via social connect
      return redirect_to link_accounts_url(user.id)
    end

    if @user.email.empty?
      flash[:alert] = "Email cannot be empty"
      redirect_to :new_user_registration
      return
    end

    if @user.password.empty?
      flash[:alert] = "Password cannot be empty"
      redirect_to :new_user_registration
      return
    end

    if params["user"]["password"] != params["user"]["password_confirmation"]
      flash[:alert] = "Password and password confirmation do not match"
      redirect_to :new_user_registration
      return
    end

    # normal processing
    begin
      super
    rescue ActiveRecord::StatementInvalid => e
      flash[:alert] = "That email address is already in use"
      redirect_to :new_user_registration
    end
    session[:omniauth] = nil unless @user.new_record?
  end

  def build_resource(*args)
    super

    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end

  def after_update_path_for(scope)
    session[:referrer] ? session[:referrer] : root_path
  end

  def after_inactive_sign_up_path_for(resource)
    :new_user_session
  end

end
