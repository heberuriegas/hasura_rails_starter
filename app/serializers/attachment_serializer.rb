class AttachmentSerializer < ActiveModel::Serializer
  attributes :id
  attributes :url
  has_one :blob
  attributes :created_at
  
  def url
    Rails.application.routes.url_helpers.rails_blob_path(object, only_path: true)
  end
end