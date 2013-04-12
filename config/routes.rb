Rareshare::Application.routes.draw do
  root to: "home#index"
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resource :profile, controller: "profile"

  match "calendar(/:id)", to: "calendar#show",  as: :calendar
  match "search",         to: "searches#show",  as: :search
  match "typeahead/:id",  to: "typeahead#show", as: :typeahead

  resources :tools do
    resources :images
  end

  resources :leases
  resources :bookings
  resources :users, only: :show
  resources :messages do
    member { post :reply }
  end
end
