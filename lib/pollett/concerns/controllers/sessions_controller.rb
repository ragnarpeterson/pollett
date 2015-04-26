module Pollett
  module Concerns
    module Controllers
      module SessionsController
        extend ActiveSupport::Concern

        included do
          skip_authentication only: [:create, :forgot]
        end

        def show
          render json: current_context, status: :ok
        end

        def create
          record = CreateSession.call(params)
          activate_context(record)
          render json: record, status: :created
        end

        def forgot
          ResetPassword.call(params)
          render json: { status: :accepted }, status: :accepted
        end

        def destroy
          current_context.revoke!
          head :no_content
        end
      end
    end
  end
end