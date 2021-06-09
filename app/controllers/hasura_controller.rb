class HasuraController < ApplicationController
  before_action :authenticate_user!

  def auth
    @response = {
      "X-Hasura-User-Id": current_user.id.to_s,
      "X-Hasura-Role": current_user.role,
    }

    render json: @response
  end
end
