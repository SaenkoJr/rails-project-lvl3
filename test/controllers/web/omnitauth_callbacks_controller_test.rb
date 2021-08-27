# frozen_string_literal: true

require 'test_helper'

class Web::OmnitauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auth_hash = OmniAuth.config.mock_auth[:github]
  end

  test 'check github auth' do
    post auth_request_path(:github)
    assert_response :redirect
    follow_redirect!
    assert { User.exists? email: @auth_hash.info.email }
  end
end
