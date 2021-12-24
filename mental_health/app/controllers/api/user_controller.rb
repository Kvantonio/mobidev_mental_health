module Api
  class UserController < ::ApiController
    before_action :authorize_request

    def get_techniques
    end

  end
end