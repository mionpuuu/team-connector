Rails.application.routes.draw do
  get 'dashboards/index'
  devise_for :users
  root to: "dashboards#index"
  resources :events
  resources :notices
end
