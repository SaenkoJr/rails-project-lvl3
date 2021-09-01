# frozen_string_literal: true

require 'test_helper'

class Web::Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test '#edit (as admin)' do
    sign_in_as :admin
    get edit_admin_user_path(@user)
    assert_response :success
  end

  test '#edit (non admin cant get edit page)' do
    sign_in_as :one
    get edit_admin_user_path(@user)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test '#update (as admin)' do
    sign_in_as :admin

    new_first_name = 'New first name'

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
    sign_in_as :one

    old_name = @user.first_name
    new_first_name = 'New first name'

    patch admin_user_path(@user), params: {
      user: {
        first_name: new_first_name
      }
    }

    @user.reload
    assert_equal @user.first_name, old_name
    assert_response :redirect
    assert_redirected_to root_path
  end

  test '#destroy (as admin)' do
    sign_in_as :admin

    assert_difference('User.count', -1) do
      delete admin_user_path(@user)
    end
  end

  test '#destroy (non admin cant delete user)' do
    sign_in_as :one

    assert_no_difference('User.count') do
      delete admin_user_path(@user)
    end

    assert_response :redirect
    assert_redirected_to root_path
  end
end
