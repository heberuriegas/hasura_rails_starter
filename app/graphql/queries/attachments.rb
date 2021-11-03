module Queries
  module Attachments
    class AttachmentsAttributes < Types::BaseInputObject
      description "Attributes for query attachments for a specific model"
      argument :record_id, Types::BigInt, "Model instance id", required: true
      argument :record_type, String, "Model class name", required: true
      argument :attribute, String, "Model attribute name", required: true
    end

    def self.included(c)
      # attach the field here
      c.field :attachment, Types::AttachmentType, null: true, description: "File relation for active storage models" do
        argument :input, AttachmentsAttributes, required: true
      end
      c.field :attachments, [Types::AttachmentType], null: false, description: "Attachments relation for active storage models" do
        argument :input, AttachmentsAttributes, required: true
      end
    end
  
    def attachment(input:)
      attachment = ActiveStorage::Attachment.find_by(record_type: input.record_type, record_id: input.record_id, name: input.attribute)
      ActiveModelSerializers::SerializableResource.new(attachment).as_json
    end

    def attachments(input:)
      attachments = ActiveStorage::Attachment.where(record_type: input.record_type, record_id: input.record_id, name: input.attribute)
      ActiveModelSerializers::SerializableResource.new(attachments).as_json
    end
  end
end