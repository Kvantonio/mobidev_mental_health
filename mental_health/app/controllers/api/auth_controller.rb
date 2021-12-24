module Api
  class AuthController < ::ApiController
    # before_action :require_jwt

    def user_login
      @user = User.find_by_email(params[:email])

      if @user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: @user.id)

        render json: { token: token, user: @user }, status: :ok
      else
        render json: { error: 'unauthorized' }, status: :unauthorized
      end
    end

    def coach_login
      @coach = Coach.find_by_email(params[:email])

      if @coach&.authenticate(params[:password])
        token = JsonWebToken.encode(coach_id: @coach.id)

        render json: { token: token, coach: @coach }, status: :ok
      else
        render json: { error: 'unauthorized' }, status: :unauthorized
      end
    end

  end
end