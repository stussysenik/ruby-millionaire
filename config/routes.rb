Rails.application.routes.draw do
  # Authentication
  resource :session
  resources :passwords, param: :token
  resource :registration, only: %i[new create]

  # Public storefront
  root "storefront#index"
  resources :products, only: %i[index show]
  resources :categories, only: %i[show]

  # Cart
  resource :cart, only: %i[show] do
    resources :cart_items, only: %i[create update destroy], path: "items"
  end

  # Checkout
  resources :checkouts, only: %i[create] do
    collection do
      get :success
      get :cancel
    end
  end

  # Webhooks
  namespace :webhooks do
    resource :stripe, only: :create, controller: "stripe"
  end

  # Account
  namespace :account do
    resource :profile, only: %i[show edit update]
    resources :orders, only: %i[index show]
    resources :addresses
  end

  # Admin
  namespace :admin do
    root "dashboard#index"
    resources :products
    resources :categories
    resources :orders, only: %i[index show update]
    resources :users, only: %i[index show edit update]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
