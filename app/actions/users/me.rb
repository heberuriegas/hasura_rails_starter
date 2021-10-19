class Users::Me < HasuraHandler::Action
  action_name :me

  def run
    user_id = @session_variables['x-hasura-user-id']

    user = User.find(user_id)
    @output = UserSerializer.new(user).as_json
  end
end