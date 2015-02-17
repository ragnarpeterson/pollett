module Pollett
  module Services
    class Base
      attr_reader :params

      def initialize(params)
        @params = params
      end

      def perform
        raise NotImplementedError, "Service objects must implement #perform."
      end

      def self.perform(params)
        new(params).perform
      end

      private
      def user_model
        Pollett.config.user_model
      end
    end
  end
end
