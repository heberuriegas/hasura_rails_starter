class ExampleAction < HasuraHandler::Action
  action_name :example_action

  def run
    @output = { hello: 'world!' }
  end
end