class ResetUserPasswordController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email]) if params[:email]
    if @user
      ResetPasswordMailer.with(user: @user).user_reset_password.deliver_now
      render :create
    else
      render :new
    end
  end

  def edit
    @user = User.find_signed!(params[:token], purpose: 'user_reset_password_verify')

  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to user_login_path, alert: 'Your token has expired. Please try again.'
  end

  def update
    @user = User.find_signed!(params[:token], purpose: 'user_reset_password_verify')

    if @user.update(user_password_params)
      redirect_to user_login_path
    else
      render :edit
    end
  end

  def resend
    @user = User.find_by_id(session[:user_id]) if session[:user_id]
    ResetPasswordMailer.with(user: @user).user_reset_password.deliver_now
    render :create
  end

  private

  def user_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
