# frozen_string_literal: true

require 'test_helper'

class Web::Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:one)
  end

  test '#index (as admin)' do
    sign_in_as_with_github :admin
    get admin_categories_path
    assert_response :success
  end

  test '#index (non admin cant get index page)' do
    sign_in_as_with_github :one
    get admin_categories_path
    assert_redirected_to root_path
  end

  test '#new (as admin)' do
    sign_in_as_with_github :admin
    get new_admin_category_path
    assert_response :success
  end

  test '#new (non admin cant get new page)' do
    sign_in_as_with_github :one
    get new_admin_category_path
    assert_redirected_to root_path
  end

  test '#create (as admin)' do
    sign_in_as_with_github :admin
    params = {
      category: attributes_for(:category)
    }

    assert_difference('Category.count', +1) do
      post admin_categories_path, params: params
    end

    category = Category.last
    assert_equal category.name, params[:category][:name]
  end

  test '#create (non admin cant create category)' do
    sign_in_as_with_github :one

    params = {
      category: attributes_for(:category)
    }

    assert_no_difference('Category.count') do
      post admin_categories_path, params: params
    end

    assert_redirected_to root_path
  end

  test '#edit (as admin)' do
    sign_in_as_with_github :admin
    get edit_admin_category_path(@category)
    assert_response :success
  end

  test '#edit (non admin cant get edit page)' do
    sign_in_as_with_github :one
    get edit_admin_category_path(@category)
    assert_redirected_to root_path
  end

  test '#update (as admin)' do
    sign_in_as_with_github :admin

    params = {
      category: attributes_for(:category)
    }

    patch admin_category_path(@category), params: params

    @category.reload
    assert_redirected_to admin_categories_path
    assert_equal @category.name, params[:category][:name]
  end

  test '#update (non admin cant update user)' do
    sign_in_as_with_github :one

    old_name = @category.name
    params = {
      category: attributes_for(:category)
    }

    patch admin_category_path(@category), params: params

    @category.reload
    assert_equal @category.name, old_name
    assert_redirected_to root_path
  end

  test '#destroy (as admin)' do
    sign_in_as_with_github :admin

    assert_difference('Category.count', -1) do
      delete admin_category_path(@category)
    end

    assert_redirected_to admin_categories_path
  end

  test '#destroy (non admin cant delete user)' do
    sign_in_as_with_github :one

    assert_no_difference('Category.count') do
      delete admin_category_path(@category)
    end

    assert_redirected_to root_path
  end
end
