module Pollett
  class KeySerializer < ActiveModel::Serializer
    include Concerns::Serializers::ContextSerializer
  end
end
