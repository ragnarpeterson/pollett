require "pollett/session_serializer"
require "pollett/services/session_creator"
require "pollett/services/password_resetter"

module Pollett
  class SessionsController < ::ApplicationController
    before_filter :authenticate!, only: [:show, :destroy]

    def show
      render_ok(current_session)
    end

    def create
      record = Services::SessionCreator.perform(params)
      activate_session(record)
      render_created(record)
    end

    def forgot
      Services::PasswordResetter.perform(params)
      render_status(:accepted)
    end

    def destroy
      current_session.revoke!
      render_no_content
    end
  end
end
