module Coaches
  class LoginService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      coach_exist
      password_valid
      @coach
    end

    private

    def coach_exist
      @coach = Coach.find_by(email: @params[:email])
      raise ServiceError, 'Password or email is invalid' if @coach.nil?
    end

    def password_valid
      raise ServiceError, 'Password or email is invalid' unless @coach.authenticate(@params[:password])
    end
  end
end

