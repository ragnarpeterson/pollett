module Pollett
  module Concerns
    module Serializers
      module ContextSerializer
        extend ActiveSupport::Concern

        included do
          attributes :id,
                     :token,
                     :client,
                     :active,
                     :ip,
                     :user_agent,
                     :accessed_at,
                     :created_at,
                     :updated_at

          has_one :user
        end
      end
    end
  end
end
