# frozen_string_literal: true

require 'test_helper'

class Web::SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'github auth' do
    post auth_request_path('github')
    assert_response :redirect
  end

  test 'sign up via github' do
    github_params = OmniAuth.config.mock_auth[:github]

    get auth_callback_url(:github)
    assert_redirected_to root_path

    user = User.find_by(email: github_params[:info][:email])
    assert { user }
    assert { signed_in? }
  end
end
