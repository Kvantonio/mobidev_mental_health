module Users
  class PasswordUpdateService < ApplicationService
    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      check_old_password
      update_password
    end

    private

    def check_old_password
      raise ServiceError, 'Old password does not match' if BCrypt::Password.new(@user.password_digest) == @params[:user][:old_password]
    end

    def update_password
      raise ServiceError, 'New password invalid' if @user.update(update_params)
    end

    def update_params
      @params.require(:user).permit(:password, :password_confirmation)
    end

end

