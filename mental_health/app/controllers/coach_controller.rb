class CoachController < ApplicationController
  before_action :check_coach_login!

  def edit
    @coach = Coach.find_by_id(session[:coach_id])
    @problems = Problem.all
  end

  def update
    @coach = Coach.find_by_id(session[:coach_id])
    #TODO: check [] params (__ in db)
    if @coach.update(coach_update_params)
      params[:coach][:problems]&.each do |problem|
        problem_object = Problem.find_by_title(problem)
        @coach.problems << problem_object unless @coach.problems.include?(problem_object)
      end

      params[:coach][:educations]&.each do |education|
        @coach.diplomas << Diploma.create(title: education)
      end

      params[:coach][:experiences]&.each do |experience|
        @coach.experiences << Experience.create(title: experience)
      end

      params[:coach][:certificates]&.each do |certificate|
        @coach.certificates << Certificate.create(title: certificate)
      end

      params[:coach][:networks]&.each do |network|
        @coach.social_networks << SocialNetwork.create(title: network)
      end

      @coach.coach_notifications.create(description: 'You changed your profile settings', status: 1)

      redirect_to coach_dashboard_path
    else
      render :edit
    end
  end

  def edit_password
    @coach = Coach.find_by_id(session[:coach_id])
  end

  def update_password
    @coach = Coach.find_by_id(session[:coach_id])
    if BCrypt::Password.new(@coach.password_digest) == params[:coach][:old_password]
      if @coach.update(coach_password_permit_params)
        @coach.coach_notifications.create(description: 'You changed your password settings', status: 1)
        redirect_to coach_dashboard_path
      else
        render :password_edit
      end
    else
      render :password_edit
    end
  end

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

  def technique_detail
    @coach = Coach.find_by_id(session[:coach_id])
    @technique = Technique.find_by_id(params[:technique_id])
    @steps = @technique.steps
  end

  def modal_user_recommend
    @coach = Coach.find_by_id(session[:coach_id])
    @invitations = @coach.invitations.where(status: true)
    @html_name = __method__.to_s
    respond_to do |format|
      format.html
      format.js {
        render 'add_modal_window.js.erb'
      }
    end
  end

  def user_recommend
    @coach = Coach.find_by_id(session[:coach_id])
    @technique = Technique.find_by_id(params[:technique_id])
    users = User.where(name: params[:users])

    users&.each do |user|
      if user.recommendations.find_by(technique_id: @technique.id).nil?
        user.recommendations.create(coach_id: @coach.id, technique_id: @technique.id, current_step: 0)
        user.user_notifications.create(description: "Coach #{@coach.name} recommended a Technique for you",
                                       coach_id: @coach.id, status: 1)
      # TODO: add warning
      end
    end
    redirect_back(fallback_location: root_path)
  end

  def users_page
    @coach = Coach.find_by_id(session[:coach_id])
    @invitations = @coach.invitations
    @notifications = @coach.coach_notifications.where.not(user_id: nil).order('created_at DESC')
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

  def user_detail
    @coach = Coach.find_by_id(session[:coach_id])

    @user = User.find_by_id(params[:user_id])
    @invitation = @coach.invitations.find_by(user_id: @user.id)
    redirect_to coach_users_page_path unless @user && @invitation && @invitation.status
    @notifications = @coach.coach_notifications.where(user_id: @user.id).order('created_at DESC')
  end



  private

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

  def coach_update_params
    params.require(:coach).permit(:name, :email, :coach_avatar, :about, :age, :gender)
  end

  def coach_password_permit_params
    params.require(:coach).permit(:password, :password_confirmation)
  end

end
