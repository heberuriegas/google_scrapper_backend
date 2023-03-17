# frozen_string_literal: true

require 'sidekiq/web'
require 'api_constraints'

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      get '/me', to: 'credentials#me'
      resources :keyword_searches, only: %i[index create]
      get '/active_processes', to: 'keyword_searches#active_processes'
    end
  end

  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?
end
