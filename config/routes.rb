Rails.application.routes.draw do
  get "home/index"
  resources :in_memory_search, only: [:index]
  mount Searchjoy::Engine, at: "searchjoy"

  root "home#index"
end
