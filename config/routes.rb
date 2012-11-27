Rareshare::Application.routes.draw do
  root to: "home#index"
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  match "dashboard", to: "users#dashboard", as: :dashboard
  match "search", to: "searches#show", as: :search

  resources :tools
  resources :leases
  resources :messages do
    member { post :reply }
  end
end
