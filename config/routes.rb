require 'sidekiq/web'

Rareshare::Application.routes.draw do
  root to: "home#index"

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations:      "users/registrations",
    passwords:          "users/passwords"
  }

  ActiveAdmin.routes(self)

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  resource :profile, controller: "profile"

  get "welcome"       => "profile#welcome", as: :welcome
  get "search"        => "searches#show",   as: :search
  get "typeahead/:id" => "typeahead#show",  as: :typeahead

  resources :tools do
    member { get :pricing }
  end

  resources :files

  resources :bookings do
    member do
      get  :finalize, to: "bookings#finalize"
      post :finalize, to: "bookings#pay"
      get  :cancel
    end
  end

  resources :users, only: :show
  resources :units, only: :show
  resources :facilities, only: [:edit, :update]

  resources :messages do
    member { post :reply }
  end

  get "/:page" => 'pages#show', as: :page
end
