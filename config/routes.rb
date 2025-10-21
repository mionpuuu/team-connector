Rails.application.routes.draw do
  get 'events/index'
  devise_for :users
  root to: "events#index"
  
end
