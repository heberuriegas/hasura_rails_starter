class ExampleEvent < HasuraHandler::EventHandler
  include Sidekiq::Worker
  
  match_by trigger: 'example_event'

  def run
    logger.info "Hello world!"
  end
end
