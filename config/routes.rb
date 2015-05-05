CfiOauthProvider::Application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",
                                       :registrations => 'registrations',
                                       :sessions => 'sessions' }

  # "authentications" controller is not presently being used.
  # omniauth client stuff
  #match '/auth/:provider/callback', :to => 'authentications#create'
  #match '/auth/failure', :to => 'authentications#failure'

  # Provider stuff
  match '/auth/josh_id/authorize' => 'auth#authorize'
  match '/auth/josh_id/access_token' => 'auth#access_token'
  match '/auth/josh_id/user' => 'auth#user'
  match '/oauth/token' => 'auth#access_token'

  match '/users/ldap_sign_in'

  # Account linking
  #match 'authentications/:user_id/link' => 'authentications#link', :as => :link_accounts
  #match 'authentications/:user_id/add' => 'authentications#add', :as => :add_account

  root :to => 'auth#welcome'
end
