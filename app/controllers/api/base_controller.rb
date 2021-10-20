module Api
  class BaseController < ActionController::Base  
    include GraphqlDevise::Concerns::SetUserByToken

    protect_from_forgery with: :null_session, if: -> { request.format.json? }

    rescue_from StandardError do |e|
      render json: { error: e }, status: 500
    end

    def current_user
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token &&  valid_doorkeeper_token?
    end
  end
end