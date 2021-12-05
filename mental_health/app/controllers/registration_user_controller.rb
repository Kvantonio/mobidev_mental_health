class RegistrationUserController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_permitted_params)

    if @user.save
      session[:user_id] = @user.id
      RegistrationVerifyMailer.with(user: @user).user_verify_email.deliver_now
      render :create
    else
      render :new
    end
  end

  def edit
    @problems = Problem.all
    @user = User.find_signed!(params[:token], purpose: 'user_registration_verify')
    puts @user
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to root_path, alert: 'Your token has expired. Please try again.'
  end

  def update
    @user = User.find_by(id: session[:user_id]) if session[:user_id]

    if @user.update(update_params)
      params[:user][:problems]&.each do |problem|
        @user.problems << Problem.find_by(title: problem)
      end
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    User.find_by_id(session[:user_id]).destroy if session[:user_id]
    session[:user_id] = nil
    redirect_to user_registration_path
  end

  private

  def user_permitted_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(:user_avatar, :age, :gender)
  end
end
