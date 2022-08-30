Rails.application.routes.draw do
  root 'home#index'
  get 'home', to: 'home#index'
  get 'about', to: 'about#index'
  get 'contact', to: 'contact#index'

  # course routing
  get 'courses', to: 'course#index'
  get '/courses/:slug', to: 'course#show', as: 'course'

  devise_for :users, controllers: { passwords: 'passwords' }
  get 'admins', to: 'admins#index'
  
  namespace :admins do
    resources :dashboard
    resources :categories
    resources :speakers
    resources :courses
    resources :videos
    resources :users
  end
end
