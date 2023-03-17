# frozen_string_literal: true

require 'api_constraints'

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      get '/me', to: 'credentials#me'
      resources :keyword_searches
    end
  end
end
