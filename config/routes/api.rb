Rails.application.routes.draw do
  namespace :api do
    resources :drills, only: %i[index show new create edit]
    post 'drills/grade', to: "drills#grade"
    get 'mydrills', to: 'drills#mydrills'
  end
end
