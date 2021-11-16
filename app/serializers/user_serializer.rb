class UserSerializer < ActiveModel::Serializer
  attributes :id
  attributes :name
  attributes :username
  attributes :email
  attributes :phone_number
  attributes :avatar_url
  attributes :avatar_thumbnail_url
  attributes :created_at
  attributes :updated_at
end