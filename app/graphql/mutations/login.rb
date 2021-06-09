module Mutations
  class Login < GraphqlDevise::Mutations::Login
    argument :email,                 String, required: false
    argument :password,              String, required: false
    argument :phone,                 String, required: false
    argument :country_code,          String, required: false
    argument :otp_code,              String, required: false

    def resolve(email: nil, password: nil, **attrs)
      if email.present?
        super(email: email, password: password)
      else
        resource = resource_class.find_by(phone: attrs[:phone], country_code: attrs[:country_code])
        if resource && resource.authenticate_otp(attrs[:otp_code], drift: 600)
          new_headers = set_auth_headers(resource)
          controller.sign_in(:user, resource, store: false, bypass: false) # this line throws error 401

          { authenticatable: resource, credentials: new_headers }
        else
          raise_user_error('Invalid Otp')
        end
      end
    end
  end
end