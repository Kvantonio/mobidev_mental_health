class CoachController < ApplicationController
  before_action :check_coach_login!
  def dashboard
    @coach = Coach.find_by_id(session[:coach_id])
    @notifications = @coach.coach_notifications.order('created_at')
    @invitations = @coach.invitations
    @techniques = @coach.recommendations.joins(:technique)
    @techniques_used = @coach.recommendations.joins(:technique).count
  end


end
