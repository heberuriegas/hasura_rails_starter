class ExampleAction < HasuraHandler::Action
  action_name :example_action

  def run
    user_id = @session_variables['x-hasura-user-id']

    user = User.find(user_id)

    if user
      @output = { user: UserSerializer.new(user) }
    else
      @error_message = 'User doesn\'t exist'
    end
  end
end