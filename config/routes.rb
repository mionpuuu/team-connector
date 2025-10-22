Rails.application.routes.draw do
  devise_for :users
  root to: "dashboards#index"
  resources :events, only:[:index, :new, :create, :show]
  resources :notices, only: [:index,:new, :create, :show]
end
