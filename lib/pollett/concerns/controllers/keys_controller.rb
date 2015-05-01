module Pollett
  module Concerns
    module Controllers
      module KeysController
        extend ActiveSupport::Concern

        def index
          render_list(scoped)
        end

        def create
          key = current_user.keys.create!(safe_params)
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
          current_user.keys.active
        end
      end
    end
  end
end
