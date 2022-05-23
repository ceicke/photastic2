require 'sidekiq/web'
Rails.application.routes.draw do
  devise_scope :user do
    # Redirests signing out users back to sign-in
    get "users", to: "devise/sessions#new"
  end
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  # Defines the root path route ("/")
  root "albums#index"

  resources :albums do
    resources :pictures, only: [:show, :new, :edit, :create, :update, :destroy] do
      resources :comments, only: [:create, :destroy]
    end
    resources :videos , only: [:show, :new, :edit, :create, :update, :destroy] do
      resources :comments, only: [:create, :destroy]
    end
  end

  post 'api/video_callback'
  mount Sidekiq::Web => '/sidekiq'
end
