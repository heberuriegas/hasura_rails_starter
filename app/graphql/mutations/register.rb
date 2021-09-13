module Mutations
  class Register < GraphqlDevise::Mutations::Register
    argument :email, String, required: false
    argument :password, String, required: false
    argument :password_confirmation, String, required: false
    argument :name, String, required: true
    argument :phone_number, String, required: false
    # Uncomment this line to allow role as argument
    # argument :role, Types::RoleType

    field :authenticatable, Types::UserType, null: true

    def resolve(**attrs)
      if attrs[:email].present? && attrs[:password].present? && attrs[:password_confirmation].present?
        original_payload = super
        original_payload.merge(authenticatable: original_payload[:authenticatable])
      elsif attrs[:phone_number].present?
        def provider
          :phone_number
        end
        resource = User.find_by(phone_number: attrs[:phone_number])
        if resource
          resource.update_attribute(:name, attrs[:name]) unless resource.name == attrs[:name]
          { authenticatable: resource, credentials: nil }
        else
          original_payload = super
          original_payload.merge(authenticatable: original_payload[:authenticatable], credentials: nil)
        end
      else
        raise_user_error('Invalid login data')
      end
    end
  end
end