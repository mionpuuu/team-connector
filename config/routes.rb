Rails.application.routes.draw do
  get 'notices/new'
  get 'notices/create'
  get 'notices/show'
  get 'dashboards/index'
  devise_for :users
  root to: "dashboards#index"
  resources :events
  resources :notices
end
