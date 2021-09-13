module Types
  class UserType < GraphQL::Schema::Object
    field :id,            Int,    null: false
    field :email,         String, null: true
    field :name,          String, null: false
    field :phone_number,  String, null: false
    field :role,          String, null: false
    field :created_at,    String, null: false
    field :updated_at,    String, null: false
  end
end