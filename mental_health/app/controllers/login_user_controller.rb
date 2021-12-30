class LoginUserController < ApplicationController
  def new
  end

  def create
    @user = Users::LoginService.call(params)
    session[:user_id] = @user.id
    redirect_to user_dashboard_path

  rescue ServiceError => e
    flash[:error] = e.message
    render :new
  end

  def logout
    session[:user_id] = nil if session[:user_id]
    redirect_to root_path
  end
end
