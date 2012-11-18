Rareshare::Application.routes.draw do
  root to: "home#index"
  devise_for :users

  match "dashboard", to: "users#dashboard", as: :dashboard
end
