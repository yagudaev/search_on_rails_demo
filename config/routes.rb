Rails.application.routes.draw do
  get 'home/index'
  resources :backend_simple_search, only: [:index]

  root 'home#index'
end
