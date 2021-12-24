module Api
  class RegistrationController < ::ApiController

    def user_registration
      @user = User.new(permit_params)
      if @user.save
        render json: @user, status: :created
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def coach_registration
      @coach = Coach.new(permit_params)
      if @coach.save
        render json: @coach, status: :created
      else
        render json: { errors: @coach.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def permit_params
      params.permit(:name, :email, :password, :password_confirmation, :age, :gender, :about)
    end

  end
end