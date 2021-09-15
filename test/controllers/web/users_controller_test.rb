# frozen_string_literal: true

require 'test_helper'

class Web::UsersControllerTest < ActionDispatch::IntegrationTest
  test '#show (signed in user)' do
    user = sign_in_as_with_github :one
    get user_path user
    assert_response :success
  end

  test '#show (guest must be redirected)' do
    get user_path users(:two)
    assert_redirected_to root_path
  end

  test '#update (guest must be redirected)' do
    user = users(:two)

    user_attrs = attributes_for(:user)

    patch user_path(user), params: { user: user_attrs }
    assert_redirected_to root_path
  end

  test '#update (only current user can update his info)' do
    sign_in_as_with_github(:one)
    user = users(:two)

    user_attrs = attributes_for(:user)

    patch user_path(user), params: { user: user_attrs }
    assert_redirected_to root_path
  end

  test '#update (signed in user)' do
    user = sign_in_as_with_github :one

    user_attrs = attributes_for(:user)

    patch user_path(user), params: { user: user_attrs }

    user.reload
    assert_equal user.first_name, user_attrs[:first_name]
    assert_equal user.last_name, user_attrs[:last_name]
  end

  test '#destroy' do
    user = sign_in_as_with_github :one

    assert_difference('User.count', -1) do
      delete user_path user
    end

    assert_redirected_to root_path
  end

  test '#destroy (only current user can delete)' do
    sign_in_as_with_github :one
    user = users(:two)

    assert_no_difference('User.count') do
      delete user_path user
    end

    assert_redirected_to root_path
  end

  test '#destroy (guest must be redirected)' do
    user = users(:one)

    assert_no_difference('User.count') do
      delete user_path user
    end

    assert_redirected_to root_path
  end
end
