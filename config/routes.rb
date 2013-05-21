Rareshare::Application.routes.draw do
  root to: "home#index"

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations:      "users/registrations",
    passwords:          "users/passwords"
  }

  ActiveAdmin.routes(self)

  resource :profile, controller: "profile"

  match "calendar(/:id)", to: "calendar#show",  as: :calendar
  match "search",         to: "searches#show",  as: :search
  match "typeahead/:id",  to: "typeahead#show", as: :typeahead

  resources :tools do
    resources :images
  end

  resources :bookings do
    member { get :finalize; get :cancel }
  end

  resources :users, only: :show
  resources :messages do
    member { post :reply }
  end

  match "/:page" => 'pages#show', as: :page
end
