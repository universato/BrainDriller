Rails.application.routes.draw do
  root "drills#index"
  devise_for :users
  resources :users
  resources :drills
  resources :problems
end
