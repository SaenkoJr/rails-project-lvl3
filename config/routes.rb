# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'bulletins#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    match 'auth/:provider/callback', to: 'auth#callback', via: %i[get post], as: :callback_auth

    resource :session, only: %i[destroy]

    resources :bulletins do
      patch :archive, on: :member
    end

    scope module: :users do
      resource :profile, except: %i[new create]
    end

    namespace :admin do
      root 'bulletins#index'
      resources :users, only: %i[index edit update destroy]
      resources :categories, except: :show
      resources :bulletins, only: %i[index edit update destroy] do
        member do
          patch :publish
          patch :reject
          patch :archive
        end
      end
    end
  end
end
