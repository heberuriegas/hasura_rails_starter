module Api
  class BaseController < ActionController::Base  
    skip_forgery_protection

    rescue_from StandardError do |e|
      render json: { error: e }, status: 500
    end

    def current_user
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token &&  valid_doorkeeper_token?
    end
  end
end