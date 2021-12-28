class LoginCoachController < ApplicationController
  def new
  end

  def create
    @coach = Coaches::LoginService.call(params)
    session[:coach_id] = @coach.id
    redirect_to coach_dashboard_path

  rescue ServiceError => e
    flash[:error] = e.message
    render :new
  end

  def logout
    session[:coach_id] = nil if session[:coach_id]
    redirect_to root_path
  end
end
