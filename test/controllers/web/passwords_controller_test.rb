# frozen_string_literal: true

require 'test_helper'

class Web::PasswordsControllerTest < ActionDispatch::IntegrationTest
  test 'should get edit page' do
    get edit_password_path
    assert_response :success
  end

  test 'should update password' do
    user = users(:one)
    sign_in_as :one

    old_password_digest = user.password_digest
    old_password = 'password'
    new_password = 'newpassword'

    patch password_path, params: {
      user_password_form: {
        old_password: old_password,
        password: new_password,
        password_confirmation: new_password
      }
    }

    user.reload
    assert_response :redirect
    assert_not_equal old_password_digest, user.password_digest
  end
end
