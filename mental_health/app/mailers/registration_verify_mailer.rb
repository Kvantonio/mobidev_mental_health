class RegistrationVerifyMailer < ApplicationMailer
  def user_verify_email
    @token = params[:user].signed_id(purpose: 'user_registration_verify', expires_in: 15.minutes)
    mail(to: params[:user].email, subject: "Verify your email!")
  end
end
