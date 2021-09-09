# frozen_string_literal: true

require 'test_helper'

class Web::SessionsControllerTest < ActionDispatch::IntegrationTest
  test '#new' do
    get new_session_path
    assert_response :success
  end

  test 'sign in' do
    user = users(:one)

    post session_path, params: {
      user: {
        email: user.email,
        password: 'password'
      }
    }

    assert_response :redirect
    assert { signed_in? }
  end

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
