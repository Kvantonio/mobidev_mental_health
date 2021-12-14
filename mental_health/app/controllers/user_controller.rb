class UserController < ApplicationController
  before_action :check_user_login!

  def dashboard
    @user = User.find_by_id(session[:user_id])
    @invitation = @user.invitation
    @notifications = @user.user_notifications
    @problems = @user.problems
  end

  def techniques
    @user = User.find_by_id(session[:user_id])
  end

  def technique_detail
    @user = User.find_by_id(session[:user_id])
    @recommendation = @user.recommendations.find_by(technique_id: params[:technique_id])

    if @recommendation
      @total_steps = @recommendation.technique.steps.count
      next_step = params[:step_id].to_i + 1
      if next_step <= @total_steps
        @recommendation.update(current_step: next_step)
        @recommendation.update(started_at: Time.zone.now) if @recommendation.started_at.nil?
        @step = Step.find_by(number: next_step)
      end
    end
  end

  def restart_technique
    @user = User.find_by_id(session[:user_id])
    @recommendation = @user.recommendations.find_by(technique_id: params[:technique_id])
    if @recommendation && (@recommendation.current_step = @recommendation.technique.steps.count)
      @recommendation.update(current_step: 0, started_at: nil, finished_at: nil)
      redirect_to user_technique_detail_path(technique_id: params[:technique_id], step_id: 0)
    end
    #TODO: alert if else
  end

  def modal_finish_technique
    user = User.find_by_id(session[:user_id])
    @coach = user.invitation.coach
    @html_name = 'modal_finish_technique'
    respond_to do |format|
      format.html
      format.js {
        render 'add_modal_window.js.erb'
      }
    end
  end

  def coaches
    @coaches = Coach.all

  end

  def modal_end_cooperation
    user = User.find_by_id(session[:user_id])
    @coach = user.invitation.coach
    @html_name = 'modal_end_cooperation'
    respond_to do |format|
      format.html
      format.js {
        render 'add_modal_window.js.erb'
      }
    end
  end

  def end_cooperation
    @user = User.find_by_id(session[:user_id])
    @user.user_notifications.create(description: "You have ended cooperation with coach #{@user.invitation.coach.name}",
                                    coach_id: @user.invitation.coach.id, status: 1)
    @user.invitation&.destroy
    redirect_to user_dashboard_path
  end

  def cancel_invitation
    @user = User.find_by_id(session[:user_id])
    @user.user_notifications.create(description: "You have canceled an invitation to coach #{@user.invitation.coach.name}",
                                    coach_id: @user.invitation.coach.id, status: 1)
    @user.invitation&.destroy
    redirect_to user_dashboard_path
  end
end
