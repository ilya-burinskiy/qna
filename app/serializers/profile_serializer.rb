class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :email, :type, :created_at, :updated_at
end
