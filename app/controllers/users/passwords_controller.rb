module Users
  class PasswordsController < Devise::PasswordsController
    skip_forgery_protection if: -> { request.format.json? }
    respond_to :json

    # POST /users/password
    def create
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      yield resource if block_given?
  
      if successfully_sent?(resource)
        respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
      else
        respond_with(resource)
      end
    end
  end
end