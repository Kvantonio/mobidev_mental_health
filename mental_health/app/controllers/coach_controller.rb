class CoachController < ApplicationController
  before_action :check_coach_login!

  def dashboard
    @coach = Coach.find_by_id(session[:coach_id])
    @notifications = @coach.coach_notifications.order('created_at DESC')
    @invitations = @coach.invitations.where(status: true)

    unique_techniques_id = @coach.recommendations.pluck(:technique_id).uniq
    unique_techniques = Technique.where(id: unique_techniques_id)
    @techniques = unique_techniques
    @techniques_used = unique_techniques_id.count
    @techniques_with_like = unique_techniques.select { |t| t.ratings.sum(:like).positive? }.count
  end

  def library
    @coach = Coach.find_by_id(session[:coach_id])
    @techniques = Technique.all
    @problems = Problem.all
  end

end
