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

  get '/user/reset_password', to: 'reset_user_password#new'
  post '/user/reset_password', to: 'reset_user_password#create'
  get '/user/reset_password/verify', to: 'reset_user_password#edit'
  patch '/user/reset_password/verify', to: 'reset_user_password#update'
  get '/user/resend_reset', to: 'reset_user_password#resend'

  get '/user/dashboard', to: 'user#dashboard'
  get '/user/dashboard/:technique_id/step/:step_id', to: 'user#technique_detail', as: 'user_technique_detail'
  patch '/user/dashboard/:technique_id/restart', to: 'user#restart_technique', as: 'user_technique_restart'

  get '/user/dashboard/:technique_id/rate', to: 'user#modal_finish_technique', as: 'user_technique_rate_modal'
  post '/user/dashboard/:technique_id/rate', to: 'user#rate_technique', as: 'user_technique_rate'
  # post '/user/dashboard/:technique_id/rate/dislike', to: 'user#technique_detail', as: 'user_technique_rate_dislike'

  get '/user/dashboard/end_coop', to: 'user#modal_end_cooperation', as: 'user_end_coach_cooperation'
  delete '/user/dashboard/end_coop', to: 'user#end_cooperation', as: 'user_end_coach_cooperation_verify'


  get '/user/techniques', to: 'user#techniques'


  ############### COACH #####################################
  get '/coach/registration', to: 'registration_coach#new'
  post '/coach/registration', to: 'registration_coach#create'
  get '/coach/registration/verify', to: 'registration_coach#edit'
  patch '/coach/registration/verify', to: 'registration_coach#update'
  get '/coach/resend', to: 'registration_coach#resend'
  delete '/coach/destroy', to: 'registration_coach#destroy'

  get '/coach/login', to: 'login_coach#new'
  post '/coach/login', to: 'login_coach#create'
  get '/coach/logout', to: 'login_coach#logout'

  get '/coach/reset_password', to: 'reset_coach_password#new'
  post '/coach/reset_password', to: 'reset_coach_password#create'
  get '/coach/reset_password/verify', to: 'reset_coach_password#edit'
  patch '/coach/reset_password/verify', to: 'reset_coach_password#update'
  get '/coach/resend_reset', to: 'reset_coach_password#resend'

end
