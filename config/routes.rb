# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'bulletins#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    match 'auth/:provider/callback', to: 'auth#callback', via: %i[get post], as: :callback_auth

    resource :session, only: :destroy

    resources :bulletins, only: %i[index new show edit create update] do
      member do
        patch :archive
        patch :send_to_moderate
      end
    end

    scope module: :users do
      resource :profile, only: %i[show edit update destroy]
    end

    namespace :admin do
      root 'bulletins#index'
      resources :users, only: %i[index edit update destroy]
      resources :categories, only: %i[index new edit create update destroy]
      resources :bulletins, only: %i[index edit update] do
        member do
          patch :publish
          patch :reject
          patch :archive
        end
      end
    end
  end
end
