# frozen_string_literal: true

require 'test_helper'

class Web::UsersControllerTest < ActionDispatch::IntegrationTest
  test '#new' do
    get new_user_path
    assert_response :success
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

  test '#destroy' do
    user = users(:one)

    assert_difference('User.count', -1) do
      delete user_path user
    end

    assert_response :redirect
  end
end
