Rareshare::Application.routes.draw do
  root to: "home#index"

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations:      "users/registrations",
    passwords:          "users/passwords"
  }

  ActiveAdmin.routes(self)

  resource :profile, controller: "profile"

  match "welcome",        to: "profile#welcome", as: :welcome
  match "calendar(/:id)", to: "calendar#show",   as: :calendar
  match "search",         to: "searches#show",   as: :search
  match "typeahead/:id",  to: "typeahead#show",  as: :typeahead

  resources :tools
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

  resources :messages do
    member { post :reply }
  end

  match "/:page" => 'pages#show', as: :page
end
