Rails.application.routes.draw do
  root 'home#index'
  get 'home/index'

  devise_for :users, controllers: { passwords: 'passwords' }
  get 'admins', to: 'admins#index'
  
  namespace :admins do
    resources :dashboard
    resources :categories
    resources :speakers
    resources :courses
    resources :videos
  end
end
