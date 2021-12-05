Rails.application.routes.draw do
  root 'home_page#show'


  get '/user/registration', to: 'registration_user#new'
  post '/user/registration', to: 'registration_user#create'
  get '/user/registration/verify', to: 'registration_user#edit'
  patch '/user/registration/verify', to: 'registration_user#update'
  delete 'destroy', to: 'registration_user#destroy'

end
