# frozen_string_literal: true

FactoryBot.define do
  sequence :email do
    Faker::Internet.email
  end

  sequence :first_name do
    Faker::Name.first_name
  end

  sequence :last_name do
    Faker::Name.last_name
  end

  sequence :name do
    Faker::Lorem.sentence(word_count: 2)
  end

  sequence :description do
    Faker::Lorem.paragraph_by_chars(number: 250)
  end

  sequence :github_auth_hash do
    Faker::Omniauth.github
  end
end
