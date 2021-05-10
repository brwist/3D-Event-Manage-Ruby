require 'sidekiq/web'

Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users

  resources :home, only: :index

  root 'home#index'
  # mount Sidekiq::Web => '/sidekiq'
end
