# frozen_string_literal: true

require 'test_helper'

class Web::Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test '#edit (as admin)' do
    sign_in_as_with_github :admin
    get edit_admin_user_path(@user)
    assert_response :success
  end

  test '#edit (non admin cant get edit page)' do
    sign_in_as_with_github :one
    get edit_admin_user_path(@user)
    assert_redirected_to root_path
  end

  test '#update (as admin)' do
    sign_in_as_with_github :admin

    new_first_name = generate(:first_name)

    patch admin_user_path(@user), params: {
      user: {
        first_name: new_first_name
      }
    }

    @user.reload
    assert_response :redirect
    assert_equal @user.first_name, new_first_name
  end

  test '#update (non admin cant update user)' do
    sign_in_as_with_github :one

    old_name = @user.first_name
    new_first_name = generate(:first_name)

    patch admin_user_path(@user), params: {
      user: {
        first_name: new_first_name
      }
    }

    @user.reload
    assert_equal @user.first_name, old_name
    assert_redirected_to root_path
  end

  test '#delete (as admin)' do
    sign_in_as_with_github :admin

    assert_difference('User.count', -1) do
      delete admin_user_path users(:two)
    end

    assert_redirected_to admin_root_path
  end

  test '#delete (non admin cant delete user)' do
    sign_in_as_with_github :one
    user = users(:two)

    assert_no_difference('User.count') do
      delete admin_user_path user
    end

    assert_redirected_to root_path
  end
end
