# frozen_string_literal: true

require 'test_helper'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulletin = bulletins(:one)
    @published = bulletins(:two)
  end

  test '#new (signed in user)' do
    sign_in_as(:one)
    get new_bulletin_path
    assert_response :success
  end

  test '#new (guest must be redirected to root path)' do
    get new_bulletin_path
    assert_redirected_to root_path
  end

  test '#show' do
    get bulletin_path @bulletin
    assert_response :success
  end

  test '#edit (as author)' do
    sign_in_as(:one)
    get edit_bulletin_path @bulletin
    assert_response :success
  end

  test '#edit (non author must be redirected)' do
    sign_in_as(:two)
    get edit_bulletin_path @published
    assert_redirected_to root_path
  end

  test '#edit (guest must be redirected to root path)' do
    get edit_bulletin_path @bulletin
    assert_redirected_to root_path
  end

  test '#create (signed in user)' do
    user = sign_in_as(:one)
    category = categories(:one)

    params = {
      moderate: true,
      bulletin: attributes_for(
        :with_photo,
        category_id: category.id
      )
    }

    assert_difference('Bulletin.count', +1) do
      post bulletins_path, params: params
    end

    bulletin = Bulletin.last
    assert_equal bulletin.name, params[:bulletin][:name]
    assert_equal bulletin.category, category
    assert_equal bulletin.author, user
    assert bulletin.on_moderate?
  end

  test '#create (save as draft)' do
    sign_in_as(:one)
    category = categories(:one)

    params = {
      bulletin: attributes_for(:bulletin, category_id: category.id)
    }

    assert_difference('Bulletin.count', +1) do
      post bulletins_path, params: params
    end

    bulletin = Bulletin.last
    assert_equal bulletin.name, params[:bulletin][:name]
    assert bulletin.draft?
  end

  test '#create (guest must be redirected to root path)' do
    category = categories(:one)

    params = {
      bulletin: attributes_for(:bulletin, category_id: category.id)
    }

    post bulletins_path, params: params

    assert_redirected_to root_path
  end

  test '#update (as author)' do
    sign_in_as(:one)

    new_category = categories(:two)
    params = {
      moderate: true,
      bulletin: attributes_for(:bulletin, category_id: new_category.id)
    }

    patch bulletin_path @bulletin, params: params

    @bulletin.reload
    assert_equal @bulletin.name, params[:bulletin][:name]
    assert_equal @bulletin.category, new_category
    assert @bulletin.on_moderate?
  end

  test '#update (non author must be redirected to root path)' do
    sign_in_as(:two)

    params = {
      bulletin: {
        name: generate(:name)
      }
    }

    patch bulletin_path @bulletin, params: params

    assert_redirected_to root_path
  end

  test '#update (guest must be redirected to root path)' do
    params = {
      bulletin: {
        name: generate(:name)
      }
    }

    patch bulletin_path @bulletin, params: params

    assert_redirected_to root_path
  end

  test '#archive (as author)' do
    sign_in_as(:one)

    patch archive_bulletin_path @published

    @published.reload
    assert @published.archived?
    assert_redirected_to @published
  end

  test '#archive (none author must be redirected)' do
    sign_in_as(:two)

    patch archive_bulletin_path @published

    @published.reload
    assert @published.published?
    assert_redirected_to root_path
  end

  test '#archive (guest must be redirected)' do
    patch archive_bulletin_path @published

    @published.reload
    assert @published.published?
    assert_redirected_to root_path
  end
end
