Rails.application.routes.draw do
  root 'home#index'
  get 'home', to: 'home#index'
  get 'about', to: 'about#index'

  # course routing
  get 'courses', to: 'course#index'
  get '/courses/:slug', to: 'course#show', as: 'course'

  # order and payment
  get '/checkout/:id/order', to: 'orders#show', as: 'checkout'
  post '/payment/:id/order', to: 'orders#create', as: 'order'
  post '/webhook/notification', to: 'orders#notification', as: 'notification'

  devise_for :users, controllers: { passwords: 'passwords' }
  
  namespace :admins do
    resources :dashboard
    resources :categories
    resources :speakers
    resources :courses
    resources :videos
    resources :users
  end
end
