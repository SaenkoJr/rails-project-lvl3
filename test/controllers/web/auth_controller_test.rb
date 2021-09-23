# frozen_string_literal: true

require 'test_helper'

class Web::AuthControllerTest < ActionDispatch::IntegrationTest
  test 'github auth' do
    post request_auth_path('github')
    assert_response :redirect
  end

  test 'sign up via github' do
    github_params = OmniAuth.config.mock_auth[:github]

    get callback_auth_url(:github)
    assert_redirected_to root_path

    user = User.find_by(email: github_params[:info][:email])
    assert { user }
    assert { signed_in? }
  end
end
