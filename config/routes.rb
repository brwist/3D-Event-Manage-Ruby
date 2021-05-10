require 'sidekiq/web'

Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users

  resources :home, only: :index

  root to: redirect('/admin')
  # mount Sidekiq::Web => '/sidekiq'
end
