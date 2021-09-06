# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'bulletins#index'

    post 'auth/:provider', to: 'sessions#request', as: :auth_request
    get 'auth/:provider/callback', to: 'sessions#callback', as: :auth_callback

    resource :session, only: %i[new create destroy]

    resources :users
    resource :password, only: %i[edit update]
    resources :bulletins do
      patch :archive, on: :member
    end

    namespace :admin do
      root 'home#index'
      resources :users, only: %i[edit update destroy]
      resources :categories, except: :show
      resources :bulletins, only: %i[index edit update destroy]
    end
  end
end
