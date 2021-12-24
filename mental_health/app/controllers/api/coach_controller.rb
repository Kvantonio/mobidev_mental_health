module Api
  class CoachController < ::ApiController
    before_action :authorize_coach_request

    def users

      render json: { users: @coach.invitations.joins(:user).pluck(:name, :age, :email) }, status: :ok
    end

  end
end
