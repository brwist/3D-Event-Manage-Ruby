Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users

  resources :home, only: :index
  resources :events
  resources :attendances

  root 'home#index'
end
