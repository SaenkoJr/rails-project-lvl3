# frozen_string_literal: true

require 'test_helper'

class Web::UsersControllerTest < ActionDispatch::IntegrationTest
  test '#new' do
    get new_user_path
    assert_response :success
  end

  test '#show (signed in user)' do
    user = sign_in_as :one
    get user_path user
    assert_response :success
  end

  test '#show (guest must be redirected)' do
    get user_path users(:two)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test '#create' do
    user_attrs = {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      password: 'password',
      password_confirmation: 'password'
    }

    assert_difference('User.count', +1) do
      post users_path, params: { user: user_attrs }
    end

    user = User.find_by(email: user_attrs[:email])

    assert { user.present? }
  end

  test '#update (signed in user)' do
    user = sign_in_as :one

    user_attrs = {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name
    }

    patch user_path(user), params: { user: user_attrs }

    user.reload
    assert_equal user.first_name, user_attrs[:first_name]
    assert_equal user.last_name, user_attrs[:last_name]
  end

  test '#destroy' do
    user = sign_in_as :one

    assert_difference('User.count', -1) do
      delete user_path user
    end

    assert_response :redirect
  end
end
