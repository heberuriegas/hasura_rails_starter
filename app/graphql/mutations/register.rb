module Mutations
  class Register < GraphqlDevise::Mutations::Register
    argument :name, String, required: false
    # Uncomment this line to allow role as argument
    # argument :role, Types::RoleType

    field :authenticatable, Types::UserType, null: true

    def resolve(email:, **attrs)
      original_payload = super
      original_payload.merge(authenticatable: original_payload[:authenticatable])
    end
  end
end