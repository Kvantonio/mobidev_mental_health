class ApplicationController < ActionController::Base
  add_flash_types :warning, :info, :error, :success

  def check_user_login!
    redirect_to user_login_path unless session[:user_id]
  end

  def check_coach_login!
    redirect_to coach_login_path unless session[:coach_id]
  end

end
