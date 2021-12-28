class UserController < ApplicationController
  before_action :check_user_login!, :set_user

  def dashboard
    @invitation = @user.invitation
    @notifications = @user.notifications.where(coach_id: nil).order('created_at DESC')
    @problems = @user.problems
  end

  def edit
    @problems = Problem.all
  end

  def update
    if @user.update(user_update_params)
      params[:user][:problems]&.each do |problem|
        problem_object = Problem.find_by_title(problem)
        @user.problems << problem_object unless @user.problems.include?(problem_object)
      end
      @user.notifications.create(description: 'You changed your profile settings', status: 1)
      # TODO: do flash message
      redirect_to user_dashboard_path
    else
      render :edit
    end
  end

  def edit_password
  end

  def update_password
    if BCrypt::Password.new(@user.password_digest) == params[:user][:old_password]
      if @user.update(user_update_password_params)
        @user.notifications.create(description: 'You changed your password settings', status: 1)
        redirect_to user_dashboard_path
      else
        render :edit_password
      end
    else
      render :edit_password
    end
  end

  def techniques
    @recommendations = @user.recommendations
    @invitation = @user.invitation
  end

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
    @html_name = __method__.to_s
    respond_to do |format|
      format.html
      format.js {
        render 'add_modal_window.js.erb'
      }
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

  def coaches_page
    @invitation = @user.invitation
    @problems = Problem.all
    coaches = Coach.all
    if params[:filter].present?
      coaches_expertise = filter_by_expertise(params[:filter][:problems], coaches)
      coaches_users = filter_by_users_count(params[:filter][:users], coaches_expertise)
      coaches_gender = filter_by_gender(params[:filter][:gender], coaches_users)
      @coaches = filter_by_age(params[:filter][:age], coaches_gender)
    else
      @coaches = coaches
    end

  end

  def modal_send_invitation
    @coach = Coach.find_by_id(params[:coach_id])
    @invitation = @user.invitation
    @html_name = __method__.to_s
    respond_to do |format|
      format.html
      format.js {
        render 'add_modal_window.js.erb'
      }
    end
  end

  def send_invitation
    @coach = Coach.find_by_id(params[:coach_id]) if params[:coach_id]

    if @coach && @user.invitation.nil?
      Invitation.create(coach_id: @coach.id, user_id: @user.id, status: false)
      @user.notifications.create(description: "You have sent an invitation to coach #{@coach.name}", status: 1)
      @coach.notifications.create(description: "You have received an invitation to become a coach from a user #{@user.name}", user_id: @user.id, status: 1)
    end
    redirect_to user_dashboard_path
  end

  def modal_cancel_invitation
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
    @user.notifications.create(description: "You have canceled an invitation to coach #{@user.invitation.coach.name}",
                                    coach_id: @user.invitation.coach.id, status: 1)
    @user.invitation&.destroy
    redirect_to user_dashboard_path
  end

  def modal_end_cooperation
    @coach = @user.invitation.coach
    @html_name = __method__.to_s
    respond_to do |format|
      format.html
      format.js {
        render 'add_modal_window.js.erb'
      }
    end
  end

  def end_cooperation
    @user.notifications.create(description: "You have ended cooperation with coach #{@user.invitation.coach.name}",
                               status: 1)
    @user.invitation&.destroy
    redirect_to user_dashboard_path
  end

  private

  def set_user
    @user = User.find_by_id(session[:user_id])
  end

  def user_update_params
    params.require(:user).permit(:name, :email, :user_avatar, :about, :age, :gender)
  end

  def user_update_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def filter_by_expertise(params, coaches)
    params ? Problem.find_by(title: params).coaches : coaches
  end

  def filter_by_gender(params, coaches)
    params.nil? || params.include?(' ') ? coaches : coaches.where(gender: params)
  end

  def filter_by_age(params, coaches)
    params.nil? || params.include?(' ') ? coaches : coaches.where(params)
  end

  def filter_by_users_count(params, coaches)
    return coaches if params.nil?

    array = []
    coaches&.each do |coach|
      count = coach.invitations.where(status: 1).count
      params.each do |user_total|
        array << coach.id if (user_total == '5') && (count <= 5)
        array << coach.id if (user_total == '5-10') && (count > 5) && (count <= 10)
        array << coach.id if (user_total == '10-20') && (count > 10) && (count <= 20)
        array << coach.id if (user_total == '20') && (count > 20)
      end
    end
    array.uniq!
    coaches.where(id: array)
  end
end
