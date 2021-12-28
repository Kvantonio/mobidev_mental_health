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

    Coaches::EditProfileService.call(@coach, params)
    redirect_to coach_login_path

  rescue ServiceError => e
    flash[:error] = e.message
    render :edit
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

end
