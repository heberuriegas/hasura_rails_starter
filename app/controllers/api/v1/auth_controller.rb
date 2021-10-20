module Api
  module V1
    class AuthController < Api::BaseController
      before_action :doorkeeper_authorize!, except: [:hasura]

      def hasura
        @response = {
          "X-Hasura-Role": 'anonymous',
        }
        if current_user && current_user.is_active?
          @response = {
            "X-Hasura-User-Id": current_user.id.to_s,
            "X-Hasura-Role": 'user',
          }
        end
        render json: @response
      end

      def user
        render json: current_user, status: 202
      end
    end
  end
end
