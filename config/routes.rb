# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-status/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, path: 'accounts'
  authenticated :user do
    root to: 'flows#index', as: :authenticated_root
  end

  root to: 'home#index'

  resources :runs, only: %i[index new create]
  resources :flows, shallow: true do
    resources :actions do
      member do
        put :reorder
      end
    end
    resources :runs, only: %i[index show] do
      member do
        put :cancel
        put :resume
      end
    end

    resources :emails, controller: 'actions'
    resources :smses, controller: 'actions'
    resources :voicemails, controller: 'actions'
  end

  resources :leads do
    collection do
      delete :bulk_destroy
    end
  end
  resources :users
  resources :settings, only: %i[index edit update]

  namespace :api, defaults: { format: :json } do
    resources :leads, only: %i[create]
  end
end
