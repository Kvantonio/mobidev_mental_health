Rails.application.routes.draw do
  root 'home_page#show'

  ###################### USER ###################################
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

  ############### COACH #####################################
  get '/coach/registration', to: 'registration_coach#new'
  post '/coach/registration', to: 'registration_coach#create'
  get '/coach/registration/verify', to: 'registration_coach#edit'
  patch '/coach/registration/verify', to: 'registration_coach#update'
  get '/coach/resend', to: 'registration_coach#resend'
  delete '/coach/destroy', to: 'registration_coach#destroy'

end
