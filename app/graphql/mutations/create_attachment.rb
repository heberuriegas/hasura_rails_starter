module Mutations
  class CreateAttachment < BaseMutation
    # argument :input, Types::AttachFilesAttributes, required: true
    argument :related_id, Int, required: true
    argument :related_type, String, required: true
    argument :attribute, String, required: true
    argument :signed_id, String, required: true

    class CreateAttachmentOutput < GraphQL::Schema::Object
      field :success, Boolean, null: false
    end

    type CreateAttachmentOutput
  
    def resolve(input)
      related_id, related_type, attribute, signed_id = input.values_at(:related_id, :related_type, :attribute, :signed_id)
      related_klass = related_type.constantize.find(related_id)
      
      if context[:current_user].can? :update, related_klass
        { success: related_klass.update(attribute => signed_id) }
      else
        raise AuthorizationError
      end
    end
  end
end