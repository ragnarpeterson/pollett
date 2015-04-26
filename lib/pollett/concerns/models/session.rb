module Pollett
  module Concerns
    module Models
      module Session
        extend ActiveSupport::Concern

        CLIENT = "App"

        included do
          before_create :set_client
        end

        private
        def set_client
          self.client = CLIENT
        end
      end
    end
  end
end
