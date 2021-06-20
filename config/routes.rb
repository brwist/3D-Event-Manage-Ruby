# frozen_string_literal: true

Rails.application.routes.draw do
  resources :clients
  ActiveAdmin.routes(self)

  devise_for :attendees, controllers: { passwords: 'devise/attendees/passwords' }
  devise_for :users

  resources :events do
    post 'upload_attendees', on: :member
    post 'publish', on: :member
    post 'unpublish', on: :member
    resources :attendees
  end
  resources :contents
  resources :tokens do
    post 'attach_content_hotspot', on: :collection
    post 'attach_url_hotspot', on: :collection
  end

  resources :hotspots, only: %i[create destroy]
  resources :labels do
    patch :update_text, on: :collection
  end

  root 'events#index'
end
