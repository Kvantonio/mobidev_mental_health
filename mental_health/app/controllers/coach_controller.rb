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
    @progress = users_progress @invitations
  end

  def confirm_user
    invitation = Invitation.find_by_id(params[:invitation_id])
    if invitation
      invitation.user.user_notifications.create(
        description: "Coach #{invitation.coach.name} agreed to become your coach",
        status: 1
      )
      invitation.coach.coach_notifications.create(
        description: "You agreed to become a coach for a user #{invitation.user.name}",
        user_id: invitation.user.id, status: 1
      )
      invitation.update(status: 1)
    end
    redirect_to coach_users_page_path
  end

  def refuse_user
    invitation = Invitation.find_by_id(params[:invitation_id])
    if invitation
      invitation.user.user_notifications.create(
        description: "Coach #{invitation.coach.name} refused to become your coach",
        coach_id: invitation.coach.id, status: 1
      )
      invitation.coach.coach_notifications.create(
        description: "You have rejected #{invitation.user.name} invite",
        user_id: invitation.user.id, status: 1
      )
      invitation.destroy
    end
    redirect_to coach_users_page_path
  end

  private

  def users_progress(invitations)
    users_technique = Hash.new { |hash, key| hash[key] = [] }
    invitations.each do |invitation|
      users_technique[invitation.user.email] = []
      temp = invitation.user.recommendations
                       .where.not(started_at: nil).where(finished_at: nil)
      temp&.each { |rec| users_technique[invitation.user.email] << rec.technique.title }
      # << temp if temp != []
    end
    puts users_technique
    users_technique
  end

end
