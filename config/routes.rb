Pollett::Engine.routes.draw do
  scope shallow: true, format: false do
    resources :sessions, only: [:create] do
      collection do
        get "current", action: :show
        delete "current", action: :destroy
        post "forgot"
      end
    end
  end
end
