module Pollett
  class SessionSerializer < ActiveModel::Serializer
    include Concerns::Serializers::ContextSerializer
  end
end
