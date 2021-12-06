class ApplicationController < ActionController::Base
  def check_user_login!
    redirect_to login_path unless session[:user_id]
  end

  def check_coach_login!
    redirect_to login_path unless session[:coach_id]
  end

end
