class HasuraController < ActionController::API
  def auth
    @response = {
      "X-Hasura-User-Id": "25",
      "X-Hasura-Role": "admin",
      "X-Hasura-Is-Owner": "true",
      "X-Hasura-Custom": "custom value"
    }

    render json: @response
  end
end
