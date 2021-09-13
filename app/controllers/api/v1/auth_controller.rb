module Api
  module V1
    class AuthController < Api::BaseController
      before_action :authenticate_user!, except: [:hasura, :refresh_token]

      def hasura
        @response = {
          "X-Hasura-Role": 'anonymous',
        }

        if current_user && current_user.is_active?
          @response = {
            "X-Hasura-User-Id": current_user.id.to_s,
            "X-Hasura-Role": current_user.role,
          }
        end
        
        render json: @response
      end

      def user
        render json: current_user, status: 202
      end 

      def refresh_token
        status = false
        if (uid = request.headers['uid']).present? && (client = request.headers['client']).present?
          if (user = User.active.find_by(uid: uid)).present?
            if user.tokens[client].present? && DeviseTokenAuth::Concerns::User.tokens_match?(user.tokens[client]['last_token'], request.headers['access-token'])
              credentials = user.create_new_auth_token(client)

              response.set_header('access-token', credentials['access-token'])
              response.set_header('expiry', credentials['expiry'])
              response.set_header('client', credentials['client'])
              response.set_header('token-type', credentials['token-type'])
              response.set_header('uid', credentials['uid'])

              status = true
            end
          end
        end
        if status
          render json: {data: user.token_validation_response}
        else
          head :unauthorized
        end
      end
    end
  end
end
