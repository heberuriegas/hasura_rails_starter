class ApplicationController < ActionController::API
  include GraphqlDevise::Concerns::SetUserByToken
end
