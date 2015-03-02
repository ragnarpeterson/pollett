module Pollett
  module Controller
    extend ActiveSupport::Concern

    include ActionController::HttpAuthentication::Token::ControllerMethods

    included do
      attr_accessor :current_session

      before_filter :authenticate!
    end

    private
    def activate_session(session)
      session.access(request)
      self.current_session = session
    end

    def current_user
      current_session.try(:user)
    end

    def authenticate!
      if session = authenticate_with_http_token { |t, _| Session.authenticate(t) }
        activate_session(session)
      else
        raise Unauthorized
      end
    end

    def render_status(status, opts = {})
      render opts.merge({ status: status, json: { status: status } })
    end
  end
end
