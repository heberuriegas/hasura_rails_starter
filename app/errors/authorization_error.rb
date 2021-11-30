class AuthorizationError < StandardError
  def message
    'unauthorized operation'
  end
end