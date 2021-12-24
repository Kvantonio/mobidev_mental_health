module Api
  class AuthController < ::ApiController
    # before_action :require_jwt

    def login
      @user = User.find_by_email(params[:email])

      if @user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: @user.id)

        render json: { token: token, user: @user }, status: :ok
      else
        render json: { error: 'unauthorized' }, status: :unauthorized
      end
    end

    private

    def login_params
      params.permit(:email, :password)
    end



  end
end