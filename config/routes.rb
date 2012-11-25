Rareshare::Application.routes.draw do
  root to: "home#index"
  devise_for :users

  match "dashboard", to: "users#dashboard", as: :dashboard
  match "search", to: "searches#show", as: :search

  resources :tools
end
