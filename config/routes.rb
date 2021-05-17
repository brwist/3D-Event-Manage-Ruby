# frozen_string_literal: true

Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users

  resources :home, only: :index
  resources :events

  root 'home#index'
end
