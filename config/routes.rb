Rails.application.routes.draw do
  root "drills#index"

  draw :admin
  draw :api

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get 'edit_profile', to: 'devise/registrations#edit_profile'
    get 'change_password', to: 'devise/registrations#change_password'
  end

  resources :drills do
    resources :problems, only: [:index], controller: "drills/problems"
  end

  # get 'edit_profile', to: 'users#edit_profile', as: "edit_profile"
  get 'mydrills', to: 'drills#mydrills'
  get 'solve/:id', to: 'drills#solve', as: "solve"

  resources :drill_likes, only: [:create, :destroy]

  resources :users, only: %i[show new create edit] do
    resources :solve
  end

  get "tos" => "static_pages#tos"
  get "policy" => "static_pages#policy"
end
