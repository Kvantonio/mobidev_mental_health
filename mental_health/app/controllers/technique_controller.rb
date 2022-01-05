class TechniqueController < ApplicationController
  before_action :set_user, :set_coach

  def technique_detail
    @recommendation = @user.recommendations.find_by(technique_id: params[:technique_id])

    if @recommendation
      @total_steps = @recommendation.technique.steps.count
      next_step = params[:step_id].to_i + 1
      if next_step < @total_steps
        @recommendation.update(current_step: next_step)
        @recommendation.update(started_at: Time.zone.now) if @recommendation.started_at.nil?
        @step = Step.find_by(number: next_step)
      else
        @step = Step.find_by(number: @total_steps)
        @recommendation.update(current_step: @total_steps)
      end
    end
  end

  def restart_technique
    @recommendation = @user.recommendations.find_by(technique_id: params[:technique_id])
    if @recommendation && (@recommendation.current_step = @recommendation.technique.steps.count)
      @recommendation.update(current_step: 0, started_at: nil, finished_at: nil)
      redirect_to user_technique_detail_path(technique_id: params[:technique_id], step_id: 0)
    end
  end

  def modal_finish_technique
    respond_to do |format|
      format.html
      format.js
    end
  end

  def rate_technique
    Users::RateService.call(@user, params)
    recommendation = @user.recommendations.find_by(technique_id: params[:technique_id])
    recommendation.update(finished_at: Time.zone.now) if recommendation.finished_at.nil?
    redirect_to user_dashboard_path
  rescue ServiceError => e
    flash[:error] = e.message
    redirect_to user_dashboard_path
  end

  private

  def set_user
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def set_coach
    @coach = Coach.find_by_id(session[:coach_id]) if session[:coach_id]
  end

end
