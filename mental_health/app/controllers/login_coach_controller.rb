class LoginCoachController < ApplicationController
  def new
  end

  def create
    coach = Coach.find_by(email: params[:email]) if params[:email]

    if coach.present? && coach.authenticate(params[:password])
      session[:coach_id] = user.id
      redirect_to coach_dashboard_path
    end
  end

  def logout
    session[:coach_id] = nil if session[:coach_id]
    redirect_to root_path
  end
end
