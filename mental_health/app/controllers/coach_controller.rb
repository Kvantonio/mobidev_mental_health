class CoachController < ApplicationController
  before_action :check_coach_login!
  def dashboard
    @coach = Coach.find_by_id(session[:coach_id])
    @invitations = @coach.invitations
    @techniques = @coach.recommendations.joins(:technique)

  end


end
