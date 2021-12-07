Rails.application.routes.draw do
  get 'user/show'
  root 'home_page#show'


  get '/user/registration', to: 'registration_user#new'
  post '/user/registration', to: 'registration_user#create'
  get '/user/registration/verify', to: 'registration_user#edit'
  patch '/user/registration/verify', to: 'registration_user#update'
  get '/user/resend', to: 'registration_user#resend'
  delete '/user/destroy', to: 'registration_user#destroy'

  get '/user/login', to: 'login_user#new'
  post '/user/login', to: 'login_user#create'
  get '/user/logout', to: 'login_user#logout'

  get '/user/dashboard', to: 'user#dashboard'

end
