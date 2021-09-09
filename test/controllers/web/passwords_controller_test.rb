# frozen_string_literal: true

require 'test_helper'

class Web::PasswordsControllerTest < ActionDispatch::IntegrationTest
  test '#edit' do
    sign_in_as :one
    get edit_password_path
    assert_response :success
  end

  test '#update' do
    user = sign_in_as :one
    old_password_digest = user.password_digest
    new_password = generate(:password)

    params = {
      user_password_form: {
        old_password: 'password',
        password: new_password,
        password_confirmation: new_password
      }
    }

    patch password_path, params: params

    user.reload
    assert_response :redirect
    assert_not_equal old_password_digest, user.password_digest
  end
end
