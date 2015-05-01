Pollett::Engine.routes.draw do
  scope shallow: true, format: false do
    resources :sessions, except: [:new, :edit, :update] do
      post :forgot, on: :collection
    end

    resources :keys, except: [:new, :edit, :update]
  end
end
