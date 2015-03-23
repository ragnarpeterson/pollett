module Pollett
  module Concerns
    module Serializers
      module SessionSerializer
        extend ActiveSupport::Concern

        included do
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
    end
  end
end