Rails.application.routes.draw do
  root 'home#index'
  get 'home/index'

  devise_for :users, controllers: { passwords: 'passwords' }
  get 'admins', to: 'admins#index'
  
  namespace :admins do
    resources :categories
    resources :dashboard
  end
end
