class UserController < ApplicationController
  before_action :check_user_login!

  def dashboard
    @user = User.find_by_id(session[:user_id])
    @invitation = @user.invitation
    @notifications = @user.user_notifications
    @problems = @user.problems
  end

  def edit
    @user = User.find_by_id(session[:user_id])
    @problems = Problem.all
  end

  def update
    @user = User.find_by_id(session[:user_id])
    if @user.update(user_update_params)
      params[:user][:problems]&.each do |problem|
        problem_object = Problem.find_by_title(problem)
        @user.problems << problem_object unless @user.problems.include?(problem_object)
      end
      @user.user_notifications.create(description: 'You changed your profile settings', status: 1)
      # TODO: do flash message
      redirect_to user_dashboard_path
    else
      render :edit
    end
  end

  def edit_password
    @user = User.find_by_id(session[:user_id])
  end

  def update_password
    @user = User.find_by_id(session[:user_id])
    if BCrypt::Password.new(@user.password_digest) == params[:user][:old_password]
      if @user.update(user_update_password_params)
        @user.user_notifications.create(description: 'You changed your password settings', status: 1)
        redirect_to user_dashboard_path
      else
        render :edit_password
      end
      # TODO: do flash message
    else
      render :edit_password
    end
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
    @user = User.find_by_id(session[:user_id])
    @recommendation = @user.recommendations.find_by(technique_id: params[:technique_id])
    if @recommendation && (@recommendation.current_step = @recommendation.technique.steps.count)
      @recommendation.update(current_step: 0, started_at: nil, finished_at: nil)
      redirect_to user_technique_detail_path(technique_id: params[:technique_id], step_id: 0)
    end
    #TODO: alert if else
  end

  def modal_finish_technique
    @html_name = __method__.to_s
    respond_to do |format|
      format.html
      format.js {
        render 'add_modal_window.js.erb'
      }
    end
  end

  def rate_technique
    @user = User.find_by_id(session[:user_id])
    rating = @user.ratings.find_or_create_by(technique_id: params[:technique_id])
    if params[:like]
      rating.update(like: 1, dislike: 0)
      @user.user_notifications.create(description: 'You like your Technique', status: 1)
    elsif params[:dislike]
      rating.update(like: 0, dislike: 1)
      @user.user_notifications.create(description: 'You dislike your Technique', status: 1)
    end
    recommendation = @user.recommendations.find_by(technique_id: params[:technique_id])
    recommendation.update(finished_at: Time.zone.now) if recommendation.finished_at.nil?
    redirect_to user_dashboard_path
  end

  def coaches_page
    @user = User.find_by_id(session[:user_id])
    @coaches = Coach.all
    @problems = Problem.all
    @invitation = @user.invitation
  end

  def modal_send_invitation
    user = User.find_by_id(session[:user_id])
    @coach = Coach.find_by_id(params[:coach_id])
    @invitation = user.invitation
    @html_name = __method__.to_s
    respond_to do |format|
      format.html
      format.js {
        render 'add_modal_window.js.erb'
      }
    end
  end

  def send_invitation
    @user = User.find_by_id(session[:user_id])
    @coach = Coach.find_by_id(params[:coach_id]) if params[:coach_id]

    if @coach && @user.invitation.nil?
      Invitation.create(coach_id: @coach.id,user_id: @user.id, status: false )
      @user.user_notifications.create(description: "You have sent an invitation to coach #{@coach.name}", coach_id: @coach.id, status: 1)
      @coach.coach_notifications.create(description: "You have received an invitation to become a coach from a user #{@user.name}", user_id: @user.id, status: 1)
    end
    redirect_to user_dashboard_path
  end

  def modal_cancel_invitation
    @user = User.find_by_id(session[:user_id])
    @coach = @user.invitation.coach
    @html_name = __method__.to_s
    respond_to do |format|
      format.html
      format.js {
        render 'add_modal_window.js.erb'
      }
    end
  end

  def cancel_invitation
    @user = User.find_by_id(session[:user_id])
    @user.user_notifications.create(description: "You have canceled an invitation to coach #{@user.invitation.coach.name}",
                                    coach_id: @user.invitation.coach.id, status: 1)
    @user.invitation&.destroy
    redirect_to user_dashboard_path
  end

  def modal_end_cooperation
    user = User.find_by_id(session[:user_id])
    @coach = user.invitation.coach
    @html_name = __method__.to_s
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


  private

  def user_update_params
    params.require(:user).permit(:name, :email, :user_avatar, :about, :age, :gender)
  end

  def user_update_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
