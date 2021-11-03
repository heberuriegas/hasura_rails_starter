module Types
  class MutationType < Types::BaseObject
    field :attach_file, mutation: Mutations::AttachFile
    field :attach_files, mutation: Mutations::AttachFiles
  end
end
