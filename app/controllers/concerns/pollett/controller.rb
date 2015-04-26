module Pollett
  module Controller
    extend ActiveSupport::Concern

    include ActionController::HttpAuthentication::Token::ControllerMethods

    included do
      attr_accessor :current_context

      before_action :authenticate!
    end

    module ClassMethods
      def skip_authentication(options = {})
        skip_before_action(:authenticate!, options)
      end
    end

    private
    def activate_context(context)
      context.access(request)
      self.current_context = context
    end

    def current_user
      current_context.try(:user)
    end

    def authenticate!
      if context = authenticate_with_http_token { |id, _| Context.authenticate(id) }
        activate_context(context)
      else
        raise Unauthorized
      end
    end
  end
end
