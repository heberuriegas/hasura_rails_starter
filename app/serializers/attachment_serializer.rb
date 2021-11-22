class AttachmentSerializer < ActiveModel::Serializer
  attributes :id
  attributes :url
  attributes :thumbnail_url
  has_one :blob, serializer: BlobSerializer
  attributes :created_at
  
  def url
    ENV['HOST']+Rails.application.routes.url_helpers.rails_blob_path(object, only_path: true)
  end

  def thumbnail_url
    ENV['HOST']+
    Rails.application.routes.url_helpers.rails_representation_url(object.variant(object.record_type.constantize.variants[:thumbnail]).processed, only_path: true)
  end
end