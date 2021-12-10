class ResetPasswordMailer < ApplicationMailer
  def user_reset_password
    @token = params[:user].signed_id(purpose: 'user_reset_password_verify', expires_in: 15.minutes)
    mail(to: params[:user].email, subject: "Reset password!")
  end

  def coach_reset_password
    @token = params[:coach].signed_id(purpose: 'coach_reset_password_verify', expires_in: 15.minutes)
    mail(to: params[:coach].email, subject: "Reset password!")
  end
end
