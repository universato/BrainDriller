Rails.application.routes.draw do
  namespace :api do
    resources :drills, only: %i[index show new create edit]
    resources :problems, only: %i[show edit update]
    post 'drills/grade', to: "drills#grade"
    get 'drill-info/:id', to: "drills#info"
    get 'mydrills', to: 'drills#mydrills'
    resources :drill_likes, only: [:destroy]
  end
end
