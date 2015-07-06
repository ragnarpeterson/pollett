module Pollett
  module Concerns
    module Serializers
      module ContextSerializer
        extend ActiveSupport::Concern

        included do
          attributes :client,
                     :active,
                     :ip,
                     :user_agent,
                     :accessed_at,
                     :created_at,
                     :updated_at

          belongs_to :user
        end
      end
    end
  end
end
