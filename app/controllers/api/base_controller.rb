module Api
  class BaseController < ActionController::Base  
    include GraphqlDevise::Concerns::SetUserByToken

    protect_from_forgery with: :null_session, if: -> { request.format.json? }

    rescue_from StandardError do |e|
      render json: { error: e }, status: 500
    end
  end
end