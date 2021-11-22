module Callbacks
  class User < HasuraHandler::EventHandler
    include Sidekiq::Worker
  
    match_by trigger: 'user_callback'

    def run
      klass = @event.table.classify.constantize
      operation = case @event.op
      when 'INSERT'
        :create
      when 'UPDATE'
        :update
      when 'DELETE'
        :destroy
      end

      user = @event.event['data']['new']

      klass.find(user['id']).run_callbacks(operation)
    end
  end
end