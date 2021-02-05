Rails.application.routes.draw do
  get "home/index"
  resources :in_memory_search, only: [:index]
  resources :titles, only: [:show]
  mount Searchjoy::Engine, at: "searchjoy"

  root "home#index"
end
