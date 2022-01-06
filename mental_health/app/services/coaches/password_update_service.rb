module Coaches
  class PasswordUpdateService < ApplicationService
    def initialize(coach, params)
      @coach = coach
      @params = params
    end

    def call
      check_old_password
      update_password
    end

    private

    def check_old_password
      if BCrypt::Password.new(@coach.password_digest) == @params[:user][:old_password]
        raise ServiceError, 'Old password does not match'
      end
    end

    def update_password
      raise ServiceError, 'New password invalid' if @coach.update(update_params)
    end

    def update_params
      @params.require(:coach).permit(:password, :password_confirmation)
    end
  end 
end

