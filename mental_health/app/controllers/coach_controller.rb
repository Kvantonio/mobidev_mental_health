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
    @progress = users_progress @invitations
  end

  def library
    @coach = Coach.find_by_id(session[:coach_id])
    @techniques = Technique.all
    @problems = Problem.all
  end

  def technique_detail
    @coach = Coach.find_by_id(session[:coach_id])
    @technique = Technique.find_by_id(params[:technique_id])
    @steps = @technique.steps
  end

  def users_page
    @coach = Coach.find_by_id(session[:coach_id])
    @invitations = @coach.invitations
    @notifications = @coach.coach_notifications.where.not(user_id: nil)
  end

  private

  def users_progress(invitations)
    # [] unless invitations
    users_technique = Hash.new { |hash, key| hash[key] = [] }
    invitations.each do |invitation|
      users_technique[invitation.user.email] = []
      temp = invitation.user.recommendations
                       .where.not(started_at: nil).where(finished_at: nil)
      temp&.each { |rec| users_technique[invitation.user.email] << rec.technique.title}
       # << temp if temp != []
    end
    puts users_technique
    users_technique
  end

end
