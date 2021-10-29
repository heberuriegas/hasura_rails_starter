module Api
  module V1
    class AuthController < Api::BaseController
      before_action :doorkeeper_authorize!, except: [:hasura, :send_otp]

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

      def send_otp
        user = User.find_by(phone_number: send_otp_params[:phone_number])
        user.send_otp(send_otp_params.except(:phone_number)) if user.present?
        render json: {}, status: 202
      end

      def user
        render json: current_user, status: 202
      end

      private

      def send_otp_params
        params.require(:otp).permit(:phone_number, :validation_hash, :via)
      end
    end
  end
end
