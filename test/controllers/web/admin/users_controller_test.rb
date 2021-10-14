# frozen_string_literal: true

require 'test_helper'

class Web::Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test '#index (admin)' do
    sign_in_as_with_github :admin
    get admin_users_path
    assert_response :success
  end

  test '#index (non admin cant get index page)' do
    get admin_users_path
    assert_redirected_to root_path
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
    assert { @user.first_name == new_first_name }
    assert_redirected_to edit_admin_user_path(@user)
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
    assert { @user.first_name == old_name }
    assert_redirected_to root_path
  end

  test '#delete (as admin)' do
    sign_in_as_with_github :admin
    user = users(:two)

    delete admin_user_path user

    assert { !User.exists?(user.id) }
    assert_redirected_to admin_users_path
  end

  test '#delete (non admin cant delete user)' do
    sign_in_as_with_github :one
    user = users(:two)

    assert_no_difference('User.count') do
      delete admin_user_path user
    end

    assert { User.exists?(user.id) }
    assert_redirected_to root_path
  end
end
