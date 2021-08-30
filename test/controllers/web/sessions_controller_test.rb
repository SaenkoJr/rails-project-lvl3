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
end
