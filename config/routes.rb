Rails.application.routes.draw do
  resources :events
  ActiveAdmin.routes(self)

  devise_for :users

  resources :home, only: :index

  root 'home#index'
end
