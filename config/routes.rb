Rails.application.routes.draw do
  root "drills#index"
  devise_for :users, :controllers => {
    :sessions => 'users/sessions' ,
    :registrations => 'users/registrations'
  }
  resources :drills
  resources :problems
  get 'favorite-problems', to: 'problems#favorite'
  get 'solve/:id', to: 'drills#solve', as: "solve"
  get 'edit_profile', to: 'users#edit_profile', as: "edit_profile"

  namespace :api do
    resources :drills, only: %i(index show new create edit)
    post 'drills/grade', to: "drills#grade"
  end

  resources :users, only: %i(index show new create edit) do
    resources :solve
  end
end
