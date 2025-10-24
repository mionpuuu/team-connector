Rails.application.routes.draw do
  devise_for :users
  root to: "dashboards#index"

  resources :events do
    member do
      post "attend"
      post "cancel"
      post "pending"
    end

    resources :comments, only: [:create]

  collection do
      get "archive"
    end
  end

  resources :notices do
    collection do
      get "archive"
    end
  end
end
