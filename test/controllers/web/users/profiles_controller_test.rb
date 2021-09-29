# frozen_string_literal: true

require 'test_helper'

class Web::Users::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test '#show (signed in user)' do
    user = sign_in_as_with_github :one
    get profile_path user
    assert_response :success
  end

  test '#show (guest must be redirected)' do
    get profile_path users(:two)
    assert_redirected_to root_path
  end

  test '#edit (guest must be redirected)' do
    user = users(:two)

    get profile_path(user)
    assert_redirected_to root_path
  end

  test '#update (guest must be redirected)' do
    user = users(:two)

    user_attrs = attributes_for(:user)

    patch profile_path(user), params: { user: user_attrs }
    assert_redirected_to root_path
  end

  test '#update (signed in user)' do
    user = sign_in_as_with_github :one

    user_attrs = attributes_for(:user)

    patch profile_path, params: { user: user_attrs }

    user.reload
    assert_equal user.first_name, user_attrs[:first_name]
    assert_equal user.last_name, user_attrs[:last_name]
  end

  test '#destroy' do
    sign_in_as_with_github :one

    assert_difference('User.count', -1) do
      delete profile_path
    end

    assert_redirected_to root_path
  end

  test '#destroy (guest must be redirected)' do
    assert_no_difference('User.count') do
      delete profile_path
    end

    assert_redirected_to root_path
  end
end
