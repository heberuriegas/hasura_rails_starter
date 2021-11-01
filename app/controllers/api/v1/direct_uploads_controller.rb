module Api
  module V1
    class DirectUploadsController < ActiveStorage::DirectUploadsController
      # Should only allow null_session in API context, so request is JSON format
      skip_forgery_protection

      # Also, since authenticity verification by cookie is disabled, you should implement you own logic :
      before_action :doorkeeper_authorize!
    end
  end
end

