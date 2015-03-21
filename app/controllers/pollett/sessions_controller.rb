module Pollett
  class SessionsController < ApplicationController
    skip_authentication only: [:create, :forgot]

    def show
      render json: current_session, status: :ok
    end

    def create
      record = CreateSession.call(params)
      activate_session(record)
      render json: record, status: :created
    end

    def forgot
      ResetPassword.call(params)
      render json: { status: :accepted }, status: :accepted
    end

    def destroy
      current_session.revoke!
      head :no_content
    end
  end
end
