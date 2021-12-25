module Api
  class CoachController < ::ApiController
    before_action :authorize_coach_request

    def users
      invitations = @coach.invitations.where(status: true)
      users = []
      invitations.each { |invitation| users << invitation.user }

      render json: { users: users }, status: :ok
    end

  end
end
