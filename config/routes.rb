# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'home#index'

    post 'auth/:provider/callback', to: 'sessions#create'

    resource :session, only: %i[new create destroy]

    resource :user
  end
end
