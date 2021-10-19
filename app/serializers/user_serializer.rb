class UserSerializer < ActiveModel::Serializer
  attributes :id
  attributes :name
  attributes :username
  attributes :email
  attributes :phone_number
  attributes :created_at
  attributes :updated_at
end