class UserController < ApplicationController
  before_action :check_user_login!

  def dashboard
    @user = User.find_by_id(session[:user_id])
    @techniques = @user.recommendations
    @invitation = @user.invitation
    @notifications = @user.user_notifications
    @problems = @user.problems
  end
end
