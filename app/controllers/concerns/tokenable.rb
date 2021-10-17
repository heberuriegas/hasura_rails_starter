module Tokenable
  extend ActiveSupport::Concern

  included do
    
    private

    def get_credentials
      application = Doorkeeper::Application.find_by(uid: request.headers[:'Client-Id'] || params[:client_id])

      if application.present?
        access_token = Doorkeeper::AccessToken.create(
          application_id: application.id,
          resource_owner_id: resource.id,
          refresh_token: Doorkeeper::AccessToken.generate_refresh_token,
          expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
          scopes: ''
        )
  
        {
          access_token: access_token.token,
          token_type: 'Bearer',
          expires_in: access_token.expires_in,
          refresh_token: access_token.refresh_token,
          created_at: access_token.created_at.to_time.to_i
        }
      else
        {}
      end
    end
  end
end