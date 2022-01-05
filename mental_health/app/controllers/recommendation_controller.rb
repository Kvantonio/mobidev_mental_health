class RecommendationController < ApplicationController
  before_action :set_user, :set_coach

  def modal_user_recommend
    @invitations = @coach.invitations.where(status: true)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def user_recommend
    @technique = Technique.find_by_id(params[:technique_id])
    users = User.where(name: params[:users])

    users&.each do |user|
      if user.recommendations.find_by(technique_id: @technique.id).nil?
        user.recommendations.create(coach_id: @coach.id, technique_id: @technique.id, current_step: 0)
        user.notifications.create(description: "Coach #{@coach.name} recommended a Technique for you",
                                  coach_id: @coach.id, status: 1)
      end
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def set_user
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def set_coach
    @coach = Coach.find_by_id(session[:coach_id]) if session[:coach_id]
  end

end
