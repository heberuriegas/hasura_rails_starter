module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :file, Types::FileType, null: true, description: "File relation for active storage models" do
      argument :input, Types::FilesAttributes, required: true
    end
    def file(input:)
      file = ActiveStorage::Attachment.find_by(record_type: input.record_type, record_id: input.record_id)

      if file.present?
        {
          url: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
        }
      else
        nil
      end
    end

    field :files, [Types::FileType], null: false, description: "Files relation for active storage models" do
      argument :input, Types::FilesAttributes, required: true
    end
    def files(input:)
      files = ActiveStorage::Attachment.where(record_type: input.record_type, record_id: input.record_id)

      files.map do |file|
        {
          url: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
        }
      end
    end
  end
end
