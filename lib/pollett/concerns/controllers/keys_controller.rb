module Pollett
  module Concerns
    module Controllers
      module KeysController
        extend ActiveSupport::Concern

        def index
          render_list(scoped.active)
        end

        def create
          key = scoped.create!(safe_params)
          render json: key, status: :created
        end

        def show
          key = scoped.find(params[:id])
          render json: key, status: :ok
        end

        def destroy
          scoped.find(params[:id]).revoke!
          head :no_content
        end

        private
        def safe_params
          params.permit(:client)
        end

        def scoped
          current_user.keys
        end
      end
    end
  end
end
