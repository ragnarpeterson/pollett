module Pollett
  module Concerns
    module Models
      module Key
        extend ActiveSupport::Concern

        included do
          validates :client, presence: true
        end
      end
    end
  end
end
