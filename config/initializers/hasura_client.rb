require "graphql/client"
require "graphql/client/http"

module HasuraClient
  class << self
    attr_accessor :HTTP
    attr_accessor :Schema
    attr_accessor :Client
  end

  # Configure GraphQL endpoint using the basic HTTP network adapter.
  begin
    self.HTTP = GraphQL::Client::HTTP.new(ENV["HASURA_ENDPOINT"] || Rails.application.credentials.hasura[:endpoint]) do
      def headers(context)
        # Optionally set any HTTP headers
        { "X-Hasura-Admin-Secret": ENV["HASURA_GRAPHQL_ADMIN_SECRET"] || Rails.application.credentials.hasura[:graphql_admin_secret]}
      end
    end 

    # Fetch latest schema on init, this will make a network request
    self.Schema = GraphQL::Client.load_schema(self.HTTP)

    # However, it's smart to dump this to a JSON file and load from disk
    #
    # Run it from a script or rake task
    #   GraphQL::Client.dump_schema(SWAPI::HTTP, "path/to/schema.json")
    #
    # Schema = GraphQL::Client.load_schema("path/to/schema.json")

    self.Client = GraphQL::Client.new(schema: self.Schema, execute: self.HTTP)
  rescue StandardError => e
    Rails.logger.error "Graphql client intialized failed"
  end
end