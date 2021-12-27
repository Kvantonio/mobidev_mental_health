module Users
  class LoginService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      user_exist
      password_valid
      @user
    end

    private

    def user_exist
      @user = User.find_by(email: @params[:email])
      raise ServiceError, 'Password or email is invalid' if @user.nil?
    end

    def password_valid
      raise ServiceError, 'Password or email is invalid' unless @user.authenticate(@params[:password])
    end
  end
end

