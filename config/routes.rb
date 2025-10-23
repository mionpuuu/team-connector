Rails.application.routes.draw do
  devise_for :users
  root to: "dashboards#index"
  resources :events
  resources :notices, only: [:index,:new, :create, :show]
end
