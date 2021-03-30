Rails.application.routes.draw do
  get "home/index"
  namespace :in_memory do
    resources :search, only: [:index]
    resources :titles, only: [:show]
  end

  mount Searchjoy::Engine, at: "searchjoy"

  root "home#index"
end
