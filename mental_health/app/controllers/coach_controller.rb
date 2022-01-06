class CoachController < ApplicationController
  before_action :check_coach_login!, :set_coach

  def edit
    @problems = Problem.all
  end

  def update
    Coaches::EditProfileService.call(@coach, params)
    @coach.notifications.create(description: 'You changed your profile settings', status: 1)
    redirect_to coach_dashboard_path

  rescue ServiceError => e
    flash[:error] = e.message
    render :edit

  end

  def edit_password
  end

  def update_password
    Coaches::PasswordUpdateService.call(@coach, params)
    @coach.notifications.create(description: 'You changed your password', status: 1)
    redirect_to coach_dashboard_path
  rescue ServiceError => e
    flash[:error] = e.message
    render :edit_password
  end

  def dashboard
    @notifications = @coach.notifications.order('created_at DESC')
    @invitations = @coach.invitations.where(status: true)

    unique_techniques_id = @coach.recommendations.pluck(:technique_id).uniq
    unique_techniques = Technique.where(id: unique_techniques_id)
    @techniques = unique_techniques
    @techniques_used = unique_techniques_id.count
    @techniques_with_like = unique_techniques.select { |t| t.ratings.where(mark: 1).count.positive? }.count
    @progress = users_progress @invitations
  end

  def library
    @problems = Problem.all
    if params[:filter]
      techniques = Technique.all
      techniques_problems = filter_problems(params[:filter][:problems], techniques)
      techniques_gender = filter_gender(params[:filter][:gender], techniques_problems)
      @techniques = filter_status(params[:filter][:status], @coach.id, techniques_gender)
    else
      @techniques = Technique.all
    end

  end

  def technique_detail
    @technique = Technique.find_by_id(params[:technique_id])
    @steps = @technique.steps
  end


  def users_page
    @invitations = @coach.invitations
    @notifications = @coach.notifications.where.not(user_id: nil).order('created_at DESC')
    @progress = users_progress @invitations
  end

  def user_detail
    @user = User.find_by_id(params[:user_id])
    @invitation = @coach.invitations.find_by(user_id: @user.id)
    redirect_to coach_users_page_path unless @user && @invitation && @invitation.status
    @notifications = @coach.notifications.where(user_id: @user.id).order('created_at DESC')
  end



  private
  def set_coach
    @coach = Coach.find_by_id(session[:coach_id])
  end

  def users_progress(invitations)
    users_technique = Hash.new { |hash, key| hash[key] = [] }
    invitations.each do |invitation|
      users_technique[invitation.user.email] = []
      temp = invitation.user.recommendations
                       .where.not(started_at: nil).where(finished_at: nil)
      temp&.each { |rec| users_technique[invitation.user.email] << rec.technique.title }
    end
    users_technique
  end



  def coach_password_permit_params
    params.require(:coach).permit(:password, :password_confirmation)
  end

  def filter_gender(params, techniques)
    params ? techniques&.where(gender: params) : techniques
  end

  def filter_problems(params, techniques)
    params ? Problem.find_by(title: params).techniques : techniques
  end

  def filter_status(params, coach_id, techniques)
    return techniques if params.nil?
    t_p = []

    params.each do |param|
      case param
      when 'recommend'
        ## recommend if coach recommend this technique before
        temp = Recommendation.where(coach_id: coach_id).pluck(:technique_id).uniq
        techniques = techniques.where(id: temp)
      when 'new'
        techniques = techniques.where('created_at >= ?', 1.week.ago)
      when 'popular'
        ## popular if count of users on technique >= 50% users
        users_count = User.all.count / 2
        techniques&.each do |technique|
          t_p << technique if Recommendation.where(technique_id: technique.id).count >= users_count
        end
        t_p
      end
    end
    t_p == [] ? techniques : t_p
  end
end
