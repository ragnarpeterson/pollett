class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :type,
             :created_at,
             :updated_at,
             :name,
             :email
end
