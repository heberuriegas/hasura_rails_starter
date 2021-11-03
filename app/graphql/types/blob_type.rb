module Types
  class BlobType < GraphQL::Schema::Object
    field :id, String, null: false
    field :key, String, null: false
    field :filename, String, null: false
    field :content_type, String, null: false
    field :byte_size, Types::BigInt, null: false
    field :checksum, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end