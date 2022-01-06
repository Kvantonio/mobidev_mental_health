class ResetCoachPasswordController < ApplicationController
  def new
  end

  def create
    @coach = Coach.find_by(email: params[:email]) if params[:email]
    if @coach
      ResetPasswordMailer.with(coach: @coach).coach_reset_password.deliver_now
      render :create
    else
      render :new
    end
  end

  def edit
    @coach = Coach.find_signed!(params[:token], purpose: 'coach_reset_password_verify')
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to coach_login_path, alert: 'Your token has expired. Please try again.'
  end

  def update
    @coach = Coach.find_signed!(params[:token], purpose: 'coach_reset_password_verify')

    if @coach.update(password_params)
      redirect_to coach_login_path
    else
      render :edit
    end
  end

  def resend
    @coach = Coach.find_by(email: params[:email]) if params[:email]
    ResetPasswordMailer.with(coach: @coach).coach_reset_password.deliver_now
    render :create
  end

  private

  def password_params
    params.require(:coach).permit(:password, :password_confirmation)
  end
end
