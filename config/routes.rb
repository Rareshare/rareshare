Rareshare::Application.routes.draw do
  root to: "home#index"
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resource :profile, controller: "profile"

  match "search", to: "searches#show", as: :search
  match "typeahead/:id", to: "typeahead#show", as: :typeahead

  resources :tools
  resources :leases
  resources :messages do
    member { post :reply }
  end
end
