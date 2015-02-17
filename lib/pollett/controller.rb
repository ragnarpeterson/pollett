module Pollett
  module Controller
    extend ActiveSupport::Concern

    include ActionController::HttpAuthentication::Token::ControllerMethods

    included do
      attr_accessor :current_session

      rescue_from Pollett::Unauthorized do
        render_status(:unauthorized)
      end
    end

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

    def render_created(record, opts = {})
      render opts.merge(status: :created, json: record)
    end

    def render_ok(record, opts = {})
      render opts.merge(status: :ok, json: record)
    end

    def render_no_content
      head :no_content
    end
  end
end
