class UserController < ApplicationController
  before_action :check_user_login!

  def dashboard
    @user = User.find_by_id(session[:user_id])
    @techniques = @user.recommendations
    @invitation = @user.invitation
    @notifications = @user.user_notifications
    @problems = @user.problems
  end

  def techniques
    @user = User.find_by_id(session[:user_id])
  end

  def end_cooperation
    @user = User.find_by_id(session[:user_id])
    @user.user_notifications.create(body: "You have ended cooperation with coach #{@user.invitation.coach.name}",
                                    coach_id: @user.invitation.coach.id, status: 1)
    @user.invitation&.destroy
    redirect_to user_dashboard_path
  end

  def cancel_invitation
    @user = User.find_by_id(session[:user_id])
    @user.user_notifications.create(body: "You have canceled an invitation to coach #{@user.invitation.coach.name}",
                                    coach_id: @user.invitation.coach.id, status: 1)
    @user.invitation&.destroy
    redirect_to user_dashboard_path
  end
end
