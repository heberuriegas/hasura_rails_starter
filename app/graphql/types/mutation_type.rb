module Types
  class MutationType < Types::BaseObject
    field :create_attachment, mutation: Mutations::CreateAttachment
    field :create_attachments, mutation: Mutations::CreateAttachments
  end
end
