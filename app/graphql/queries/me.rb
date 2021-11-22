module Queries
  module Me
    def self.included(c)
      # attach the field here
      c.field :me, Types::UserType, null: true, description: "User of the current session"
    end
  
    def me(input:)
      user = User.find(request.headers['x-hasura-user-id'])
      UserSerializer.new(user).as_json
    end
  end
end