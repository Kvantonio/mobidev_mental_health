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
        @user.problems << problem_object unless @user.problems.include?(problem_object)
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
    params.require(:coach).permit(:name, :email, :avatar, :about, :age, :gender)
  end

  def coach_password_permit_params
    params.require(:coach).permit(:password, :password_confirmation)
  end

end
