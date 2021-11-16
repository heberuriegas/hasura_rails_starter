module Mutations
  class CreateAttachment < BaseMutation
    # argument :input, Types::AttachFilesAttributes, required: true
    argument :related_id, Int, required: true
    argument :related_type, String, required: true
    argument :attribute, String, required: true
    argument :signed_id, String, required: true

    type Boolean
  
    def resolve(input)
      related_id, related_type, attribute, signed_id = input.values_at(:related_id, :related_type, :attribute, :signed_id)
      # TODO: can? update
      related_type.constantize.find(related_id).update(attribute => signed_id)
    end
  end
end