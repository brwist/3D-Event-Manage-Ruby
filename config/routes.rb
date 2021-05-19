# frozen_string_literal: true

Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users

  resources :home, only: :index
  resources :events do
    post 'upload_attendees', on: :member
    post 'publish', on: :member
    resources :attendees
  end

  root 'home#index'
end
