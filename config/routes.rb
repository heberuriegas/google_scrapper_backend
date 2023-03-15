# frozen_string_literal: true

Rails.application.routes.draw do
  resources :keyword_searches
  use_doorkeeper
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
end
