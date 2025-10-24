Rails.application.routes.draw do
  get 'comments/create'
  devise_for :users
  root to: "dashboards#index"
  resources :events do
    member do
      post "attend"
      post "cancel"
      post "pending"
    end
    resources :comments, only: [:create]
  end
  resources :notices
end
