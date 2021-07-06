module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :files, [Types::FileType], null: false, description: "File relation for active storage models" do
      argument :attributes, Types::FilesAttributes, required: true
    end
    def files(attributes:)
      files = ActiveStorage::Attachment.where(record_type: attributes.record_type, record_id: attributes.record_id)

      files.map do |file|
        {
          url: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
        }
      end
    end
  end
end
