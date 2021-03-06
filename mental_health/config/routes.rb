Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

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
  post '/user/logout', to: 'login_user#logout'

  get '/user/reset_password', to: 'reset_user_password#new'
  post '/user/reset_password', to: 'reset_user_password#create'
  get '/user/reset_password/verify', to: 'reset_user_password#edit'
  patch '/user/reset_password/verify', to: 'reset_user_password#update'
  get '/user/resend_reset', to: 'reset_user_password#resend'

  get '/user/dashboard', to: 'user#dashboard'
  get '/user/dashboard/:technique_id/step/:step_id', to: 'technique#technique_detail', as: 'user_technique_detail'
  patch '/user/dashboard/:technique_id/restart', to: 'technique#restart_technique', as: 'user_technique_restart'
  get '/user/dashboard/:technique_id/rate', to: 'technique#modal_finish_technique', as: 'user_technique_rate_modal'
  post '/user/dashboard/:technique_id/rate', to: 'technique#rate_technique', as: 'user_technique_rate'

  get '/user/edit_profile', to: 'user#edit'
  patch '/user/edit_profile', to: 'user#update'
  get '/user/edit_password', to: 'user#edit_password'
  patch '/user/edit_password', to: 'user#update_password'

  get 'user/coaches', to: 'user#coaches_page', as: 'user_coaches_page'
  get 'user/coaches/invitation/:coach_id', to: 'invitation#modal_send_invitation', as: 'user_send_invitation'
  post 'user/coaches/invitation/:coach_id', to: 'invitation#send_invitation', as: 'user_send_invitation_verify'

  get 'user/coaches/cancel_invitation', to: 'invitation#modal_cancel_invitation', as: 'user_cancel_invitation'
  delete 'user/coaches/cancel_invitation', to: 'invitation#cancel_invitation', as: 'user_cancel_invitation_verify'

  get '/user/dashboard/end_coop', to: 'invitation#modal_end_cooperation', as: 'user_end_coach_cooperation'
  delete '/user/dashboard/end_coop', to: 'invitation#end_cooperation', as: 'user_end_coach_cooperation_verify'

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
  post '/coach/logout', to: 'login_coach#logout'

  get '/coach/reset_password', to: 'reset_coach_password#new'
  post '/coach/reset_password', to: 'reset_coach_password#create'
  get '/coach/reset_password/verify', to: 'reset_coach_password#edit'
  patch '/coach/reset_password/verify', to: 'reset_coach_password#update'
  get '/coach/resend_reset', to: 'reset_coach_password#resend'

  get '/coach/dashboard', to: 'coach#dashboard'
  get '/coach/library', to: 'coach#library'
  get '/coach/library/:technique_id', to: 'coach#technique_detail', as: 'coach_technique_detail'

  get '/coach/users', to: 'coach#users_page', as: 'coach_users_page'
  patch '/coach/users/confirm/:invitation_id', to: 'invitation#confirm_user', as: 'coach_user_confirm'
  delete '/coach/users/refuse/:invitation_id', to: 'invitation#refuse_user', as: 'coach_user_refuse'

  get '/coach/users/:user_id', to: 'coach#user_detail', as: 'coach_user_detail'

  get '/coach/edit_profile', to: 'coach#edit'
  patch '/coach/edit_profile', to: 'coach#update'

  get '/coach/edit_password', to: 'coach#edit_password'
  patch '/coach/edit_password', to: 'coach#update_password'

  get '/coach/library/:technique_id/recommend', to: 'recommendation#modal_user_recommend', as: 'coach_user_recommend'
  post '/coach/library/:technique_id/recommend', to: 'recommendation#user_recommend', as: 'coach_user_recommend_post'


  namespace :api do
    post '/user/auth', to: 'auth#user_login'
    post '/coach/auth', to: 'auth#coach_login'

    post '/user/registration', to: 'registration#user_registration'
    post '/coach/registration', to: 'registration#coach_registration'

    get '/coach/users', to: 'coach#users'
    get '/user/techniques', to: 'user#get_techniques'
    get '/user/techniques/:technique_id/steps', to: 'user#steps'

  end

end
