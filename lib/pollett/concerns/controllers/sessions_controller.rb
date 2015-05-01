module Pollett
  module Concerns
    module Controllers
      module SessionsController
        extend ActiveSupport::Concern

        included do
          skip_authentication only: [:create, :forgot]
        end

        def index
          render_list(scoped)
        end

        def show
          session = scoped.find(params[:id])
          render json: session, status: :ok
        end

        def create
          session = CreateSession.call(params)
          activate_context(session)
          render json: session, status: :created
        end

        def forgot
          ResetPassword.call(params)
          render json: { status: :accepted }, status: :accepted
        end

        def destroy
          scoped.find(params[:id]).revoke!
          head :no_content
        end

        private
        def scoped
          current_user.sessions.active
        end
      end
    end
  end
end