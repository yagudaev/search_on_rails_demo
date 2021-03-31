Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  get "home/index"
  namespace :in_memory do
    resources :search, only: [:index]
    resources :titles, only: [:show]
  end

  mount Searchjoy::Engine, at: "searchjoy"

  root "home#index"
end
