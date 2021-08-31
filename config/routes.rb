# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'home#index'

    post 'auth/:provider', to: 'sessions#request', as: :auth_request
    get 'auth/:provider/callback', to: 'sessions#callback', as: :auth_callback

    resource :session, only: %i[new create destroy]

    resources :users
    resources :bulletins
    resource :password, only: %i[edit update]
  end
end
