require 'sidekiq/web'

Rareshare::Application.routes.draw do
  root to: "home#index"

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations:      "users/registrations",
    passwords:          "users/passwords",
    confirmations:      "users/confirmations"
  }

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  ActiveAdmin.routes(self)

  resource :profile, controller: "profile"

  get "welcome"         => "profile#welcome", as: :welcome
  get "search"          => "searches#show",   as: :search
  post "search/request" => "searches#create_request", as: :search_request
  get "typeahead/:id"   => "typeahead#show",  as: :typeahead

  resources :tools do
    member { get :pricing }
  end

  resources :terms_documents
  patch "/terms_documents" => "terms_documents#create"

  resources :files

  resources :bookings do
    member do
      get  :finalize, to: "bookings#finalize"
      post :finalize, to: "bookings#pay"
      get  :approve
      get  :cancel
    end

    resources :questions do
      post :reply, to: "questions#reply"
    end
  end

  resources :booking_edits, except: [:show, :index] do
    member do
      patch 'confirm'
      patch 'decline'
    end
  end

  resources :booking_edit_requests, except: [:show, :index] do
    member do
      get 'check'
      patch 'accept'
      patch 'decline'
    end
  end


  get "/users/skills" => "users#skills"
  resources :users, only: :show
  resources :units, only: :show
  resources :facilities
  resources :notifications, only: [:index, :show]

  resources :messages do
    member { post :reply }
  end

  get "/stripe" => 'stripe#handle_redirect', as: :stripe
  get "/:page" => 'pages#show', as: :page
end
