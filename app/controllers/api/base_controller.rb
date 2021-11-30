module Api
  class BaseController < ActionController::Base  
    skip_forgery_protection

    rescue_from StandardError do |e|
      render json: { error: e }, status: 500
    end

    def current_user
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token && valid_doorkeeper_token?
    end

    protected
    def authenticate_with_service_key
      unless request.headers['X-Hasura-Service-Key'] == ENV['HASURA_SERVICE_KEY']
        render status: 403, json: {}
      end
    end
  end
end