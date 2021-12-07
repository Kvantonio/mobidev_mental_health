class LoginUserController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email]) if params[:email]

    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_dashboard_path
    end
  end

  def logout
    session[:user_id] = nil if session[:user_id]
    redirect_to root_path
  end
end
