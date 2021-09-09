# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email
    first_name
    last_name
    admin { false }

    factory :with_password do
      password { 'password' }
      password_confirmation { 'password' }
    end
  end
end
