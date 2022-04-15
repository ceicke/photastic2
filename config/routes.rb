Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "albums#index"

  resources :albums do
    resources :pictures
  end
end
