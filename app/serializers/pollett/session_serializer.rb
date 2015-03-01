module Pollett
  class SessionSerializer < ActiveModel::Serializer
    attributes :id,
               :token,
               :ip,
               :user_agent,
               :accessed_at,
               :created_at,
               :updated_at

    has_one :user
  end
end
