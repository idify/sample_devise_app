Devise2App::Application.routes.draw do
#for google account
devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
#home index controller
 root :to => "homes#index"


end
