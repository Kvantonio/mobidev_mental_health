module Users
  class RateService < ApplicationService
    def initialize(user, params)
      @params = params
      @user = user
    end

    def call
      rate
      @rating
    end

    private

    def rate
      @rating = @user.ratings.find_or_create_by(technique_id: @params[:technique_id])
      if @params[:like]
        set_like(@rating)
        @user.notifications.create(description: 'You like your Technique', status: 1)
      elsif @params[:dislike]
        set_dislike(@rating)
        @user.notifications.create(description: 'You dislike your Technique', status: 1)
      end
    end

    def set_like(rating)
      raise ServiceError, 'Failed to like' unless rating.update(like: 1, dislike: 0)
    end

    def set_dislike(rating)
      raise ServiceError, 'Failed to dislike' unless rating.update(like: 0, dislike: 1)
    end

  end
end

