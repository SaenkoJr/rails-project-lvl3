# frozen_string_literal: true

require 'test_helper'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest # rubocop:disable Metrics/ClassLength
  setup do
    @bulletin = bulletins(:one)
    @published = bulletins(:two)
  end

  test '#new (signed in user)' do
    sign_in_as_with_github(:one)
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
    sign_in_as_with_github(:one)
    get edit_bulletin_path @bulletin
    assert_response :success
  end

  test '#edit (non author must be redirected)' do
    sign_in_as_with_github(:two)
    get edit_bulletin_path @published
    assert_redirected_to root_path
  end

  test '#edit (guest must be redirected to root path)' do
    get edit_bulletin_path @bulletin
    assert_redirected_to root_path
  end

  test '#create (signed in user)' do
    user = sign_in_as_with_github(:one)
    category = categories(:one)

    params = {
      bulletin: attributes_for(
        :with_photo,
        category_id: category.id
      )
    }

    post bulletins_path, params: params

    bulletin = Bulletin.find_by(title: params[:bulletin][:title])

    assert { bulletin }
    assert { bulletin.category == category }
    assert { bulletin.user == user }
    assert { bulletin.draft? }
  end

  test '#create (guest must be redirected to root path)' do
    category = categories(:one)

    params = {
      bulletin: attributes_for(:bulletin, category_id: category.id)
    }

    assert_no_difference('Bulletin.count') do
      post bulletins_path, params: params
    end

    assert_redirected_to root_path
  end

  test '#update (as author)' do
    sign_in_as_with_github(:one)

    new_category = categories(:two)
    params = {
      bulletin: attributes_for(:bulletin, category_id: new_category.id)
    }

    patch bulletin_path @bulletin, params: params

    @bulletin.reload
    assert { @bulletin.title == params[:bulletin][:title] }
    assert { @bulletin.category == new_category }
    assert { @bulletin.draft? }
  end

  test '#update (save as draft)' do
    sign_in_as_with_github(:one)
    bulletin = bulletins(:rejected)
    category = categories(:one)

    params = {
      make_draft: true,
      bulletin: attributes_for(:bulletin, category_id: category.id)
    }

    patch bulletin_path(bulletin), params: params

    bulletin.reload
    assert { bulletin.title == params[:bulletin][:title] }
    assert { bulletin.draft? }
  end

  test '#update (non author must be redirected to root path)' do
    sign_in_as_with_github(:two)

    params = {
      bulletin: {
        title: generate(:title)
      }
    }

    patch bulletin_path @bulletin, params: params

    assert_redirected_to root_path
  end

  test '#update (guest must be redirected to root path)' do
    params = {
      bulletin: {
        title: generate(:title)
      }
    }

    patch bulletin_path @bulletin, params: params

    assert_redirected_to root_path
  end

  test '#archive (as author)' do
    sign_in_as_with_github(:one)

    patch archive_bulletin_path @published

    @published.reload
    assert { @published.archived? }
    assert_redirected_to @published
  end

  test '#archive (none author must be redirected)' do
    sign_in_as_with_github(:two)

    patch archive_bulletin_path @published

    @published.reload
    assert { @published.published? }
    assert_redirected_to root_path
  end

  test '#archive (guest must be redirected)' do
    patch archive_bulletin_path @published

    @published.reload
    assert { @published.published? }
    assert_redirected_to root_path
  end
end
