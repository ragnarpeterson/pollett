module Pollett
  module Concerns
    module Controllers
      module UsersController
        extend ActiveSupport::Concern

        def show
          render json: current_user, status: :ok
        end

        def update
          current_user.update!(safe_params)
          render json: current_user, status: :ok
        end

        def destroy
          current_user.destroy
          head :no_content
        end

        private
        def safe_params
          params.permit(:name, :email)
        end
      end
    end
  end
end
