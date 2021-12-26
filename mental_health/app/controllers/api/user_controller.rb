module Api
  class UserController < ::ApiController
    before_action :authorize_user_request

    def techniques
      techniques = []
      recommendations = @user.recommendations

      if recommendations
        recommendations.each { |recommendation| techniques << recommendation.technique }
        render json: techniques, status: :ok
      else
        render json: 'No techniques', status: :no_content
      end

    end

    def steps
      technique = @user.recommendations.find_by(technique_id: params[:technique_id])&.technique
      steps = technique.steps if technique
      if technique && steps
        render json: steps, status: :ok
      else
        render json: { techniques: 'No steps' }, status: :no_content
      end
    end

  end
end
