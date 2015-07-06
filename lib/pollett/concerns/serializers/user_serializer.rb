module Pollett
  module Concerns
    module Serializers
      module UserSerializer
        extend ActiveSupport::Concern

        included do
          attributes :created_at,
                     :updated_at,
                     :name,
                     :email
        end
      end
    end
  end
end
