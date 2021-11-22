module Types
  class UserType < GraphQL::Schema::Object
    field :id, Int, null: false
    field :name, String, null: true
    field :username, String, null: true
    field :email, String, null: true
    field :phone_number, String, null: true
    field :avatar_url, String, null: true
    field :avatar_thumbnail_url, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end