class BlobSerializer < ActiveModel::Serializer
  attributes :id
  attributes :key
  attributes :filename
  attributes :content_type
  attributes :byte_size
  attributes :checksum
  attributes :created_at

  def filename
    object.filename.to_s
  end
end