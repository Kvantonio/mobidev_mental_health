module Api
  class UserController < ::ApiController
    before_action :authorize_user_request

    def get_techniques
      techniques = []
      recommendations = @user.recommendations

      if recommendations
        recommendations.each { |recommendation| techniques << recommendation.technique }
        render json: { techniques: techniques }, status: :ok
      else
        render json: { techniques: 'No content' }, status: :no_content
      end

    end

  end
end