module Users
  class RegistrationsController < Devise::RegistrationsController
    skip_forgery_protection if: -> { request.format.json? }
    before_action :configure_sign_up_params, only: [:create]
    respond_to :json

    include Tokenable

    # POST /users
    def create
      if !sign_up_params[:email].present? && sign_up_params[:phone_number].present?
        create_resource_with_phone_number(sign_up_params)
      else
        build_resource(sign_up_params)
        resource.save
      end
      
      yield resource if block_given?
      if resource.persisted?
        if resource.auth_by_phone_number?
          respond_with({ resource_name => { phone_number: resource.phone_number } }, location: after_sign_up_path_for(resource))
        elsif resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)

          # Generate access token for json request
          if request.format.json? && resource.email_required?
            credentials = get_credentials
            respond_with({ resource_name => resource, credentials: credentials }, location: after_sign_up_path_for(resource))
          else
            respond_with({ resource_name => resource }, location: after_sign_up_path_for(resource))
          end
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end

    protected

    def create_resource_with_phone_number(sign_up_params)
      self.resource = self.resource_class.create_with(sign_up_params.except(:phone_number)).find_or_create_by(phone_number: sign_up_params[:phone_number])
    end
    
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :username])
    end
  end
end