# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'bulletins#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    match 'auth/:provider/callback', to: 'auth#callback', via: %i[get post], as: :auth_callback

    resource :session, only: %i[destroy]

    resources :users, except: %i[new create]
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
