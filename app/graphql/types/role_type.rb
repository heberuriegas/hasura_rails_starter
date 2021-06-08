module Types
  class RoleType < GraphQL::Schema::Enum
    value "ADMIN", value: :admin
    value "USER", value: :user
  end
end