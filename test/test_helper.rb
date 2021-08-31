# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(
  :github,
  Faker::Omniauth.github
)
Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:github]

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  include AuthConcern

  def sign_in_as(name)
    user = users(name)
    post session_url, params: {
      user: {
        email: user.email,
        password: 'password'
      }
    }
    user
  end
end
