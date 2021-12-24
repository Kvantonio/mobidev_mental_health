class RegistrationCoachController < ApplicationController
  def new
    @coach = Coach.new
  end

  def create
    @coach = Coach.new(coach_permitted_params)

    if @coach.save
      session[:coach_id] = @coach.id
      RegistrationVerifyMailer.with(coach: @coach).coach_verify_email.deliver_now
      render :create
    else
      render :new
    end
  end

  def edit
    @problems = Problem.all
    @coach = Coach.find_signed!(params[:token], purpose: 'coach_registration_verify')

  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to coach_registration_path, alert: 'Your token has expired. Please try again.'
  end

  def update
    @coach = Coach.find_by(id: session[:coach_id]) if session[:coach_id]

    if @coach.update(coach_update_params)
      params[:coach][:problems]&.each do |problem|
        @coach.problems << Problem.find_by(title: problem) if problem != ''
      end

      params[:coach][:educations]&.each do |education|
        @coach.diplomas << Diploma.create(title: education) if education != ''
      end

      params[:coach][:experiences]&.each do |experience|
        @coach.experiences << Experience.create(title: experience) if experience != ''
      end

      params[:coach][:certificates]&.each do |certificate|
        @coach.certificates << Certificate.create(title: certificate) if certificate != ''
      end

      params[:coach][:networks]&.each do |network|
        @coach.social_networks << SocialNetwork.create(title: network)
      end
      redirect_to root_path
    else
      render :edit
    end
  end

  def resend
    @coach = Coach.find_by_id(session[:coach_id]) if session[:coach_id]
    RegistrationVerifyMailer.with(coach: @coach).coach_verify_email.deliver_now
    render :create
  end

  def destroy
    Coach.find_by_id(session[:coach_id]).destroy if session[:coach_id]
    session[:coach_id] = nil
    redirect_to coach_registration_path
  end

  private

  def coach_permitted_params
    params.require(:coach).permit(:name, :email, :password, :password_confirmation)
  end

  def coach_update_params
    params.require(:coach).permit(:coach_avatar, :age, :gender)
  end

end
