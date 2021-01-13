Rails.application.routes.draw do
  get 'home/index'
  resources :in_memory_search, only: [:index]

  root 'home#index'
end
