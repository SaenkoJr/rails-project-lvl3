# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email
    first_name
    last_name
    admin { false }
  end
end
