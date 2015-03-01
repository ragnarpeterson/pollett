module Pollett
  class SessionsController < ApplicationController
    skip_before_filter :authenticate!, only: [:create, :forgot]

    def show
      render_ok(current_session)
    end

    def create
      record = CreateSession.call(params)
      activate_session(record)
      render_created(record)
    end

    def forgot
      ResetPassword.call(params)
      render_status(:accepted)
    end

    def destroy
      current_session.revoke!
      render_no_content
    end
  end
end
