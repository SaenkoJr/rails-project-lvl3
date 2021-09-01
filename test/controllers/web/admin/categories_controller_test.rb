# frozen_string_literal: true

require 'test_helper'

class Web::Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:one)
  end

  test '#index (as admin)' do
    sign_in_as :admin
    get admin_categories_path
    assert_response :success
  end

  test '#index (non admin cant get index page)' do
    sign_in_as :one
    get admin_categories_path
    assert_response :redirect
    assert_redirected_to root_path
  end

  test '#new (as admin)' do
    sign_in_as :admin
    get new_admin_category_path
    assert_response :success
  end

  test '#new (non admin cant get new page)' do
    sign_in_as :one
    get new_admin_category_path
    assert_response :redirect
    assert_redirected_to root_path
  end

  test '#create (as admin)' do
    sign_in_as :admin

    assert_difference('Category.count', +1) do
      post admin_categories_path, params: { category: { name: 'new category' } }
    end

    category = Category.last
    assert_equal category.name, 'new category'
  end

  test '#create (non admin cant create category)' do
    sign_in_as :one

    assert_no_difference('Category.count') do
      post admin_categories_path, params: { category: { name: 'new category' } }
    end

    assert_response :redirect
    assert_redirected_to root_path
  end

  test '#edit (as admin)' do
    sign_in_as :admin
    get edit_admin_category_path(@category)
    assert_response :success
  end

  test '#edit (non admin cant get edit page)' do
    sign_in_as :one
    get edit_admin_category_path(@category)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test '#update (as admin)' do
    sign_in_as :admin

    new_name = 'updated category'

    patch admin_category_path(@category), params: {
      category: {
        name: new_name
      }
    }

    @category.reload
    assert_response :redirect
    assert_equal @category.name, new_name
  end

  test '#update (non admin cant update user)' do
    sign_in_as :one

    old_name = @category.name
    new_name = 'updated name'

    patch admin_category_path(@category), params: {
      category: {
        name: new_name
      }
    }

    @category.reload
    assert_equal @category.name, old_name
    assert_response :redirect
    assert_redirected_to root_path
  end

  test '#destroy (as admin)' do
    sign_in_as :admin

    assert_difference('Category.count', -1) do
      delete admin_category_path(@category)
    end
  end

  test '#destroy (non admin cant delete user)' do
    sign_in_as :one

    assert_no_difference('Category.count') do
      delete admin_category_path(@category)
    end

    assert_response :redirect
    assert_redirected_to root_path
  end
end
