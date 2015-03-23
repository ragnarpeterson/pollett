module Pollett
  module Concerns
    module Controllers
      module SessionsController
        extend ActiveSupport::Concern

        included do
          skip_authentication only: [:create, :forgot]
        end

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
  end
end