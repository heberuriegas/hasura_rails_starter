module Mutations
  class AttachFile < BaseMutation
    # argument :input, Types::AttachFilesAttributes, required: true
    argument :related_id, Int, required: true
    argument :related_type, String, required: true
    argument :field, String, required: true
    argument :signed_id, String, required: true

    type Boolean
  
    def resolve(input)
      related_id, related_type, field, signed_id = input.values_at(:related_id, :related_type, :field, :signed_id)
      # TODO: can? update
      related_type.constantize.find(related_id).update(field => signed_id)
    end
  end
end