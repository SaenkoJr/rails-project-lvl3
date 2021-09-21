# frozen_string_literal: true

require 'test_helper'

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulletin = bulletins(:one)
  end

  test '#index (as admin)' do
    sign_in_as_with_github :admin
    get admin_bulletins_path(@bulletin)
    assert_response :success
  end

  test '#index (non admin cant get index page)' do
    sign_in_as_with_github :one
    get admin_bulletins_path(@bulletin)
    assert_redirected_to root_path
  end

  test '#edit (as admin)' do
    sign_in_as_with_github :admin
    get edit_admin_bulletin_path(@bulletin)
    assert_response :success
  end

  test '#edit (non admin cant get edit page)' do
    sign_in_as_with_github :one
    get edit_admin_bulletin_path(@bulletin)
    assert_redirected_to root_path
  end

  test '#update (as admin)' do
    sign_in_as_with_github :admin

    params = {
      bulletin: {
        title: generate(:title)
      }
    }

    patch admin_bulletin_path(@bulletin), params: params

    @bulletin.reload
    assert_equal @bulletin.title, params[:bulletin][:title]
  end

  test '#update (non admin cant update user)' do
    sign_in_as_with_github :one

    old_title = @bulletin.title
    params = {
      bulletin: {
        title: generate(:title)
      }
    }

    patch admin_bulletin_path(@bulletin), params: params

    @bulletin.reload
    assert_equal @bulletin.title, old_title
    assert_redirected_to root_path
  end

  test 'publish bulletin' do
    sign_in_as_with_github :admin
    bulletin = bulletins(:without_description)

    params = { bulletin: { state_event: :publish } }
    patch admin_bulletin_path(bulletin), params: params
    assert bulletin.reload.published?
  end

  test 'reject bulletin' do
    sign_in_as_with_github :admin
    bulletin = bulletins(:without_description)

    params = { bulletin: { state_event: :reject } }
    patch admin_bulletin_path(bulletin), params: params
    assert bulletin.reload.rejected?
  end

  test 'archive bulletin' do
    sign_in_as_with_github :admin
    bulletin = bulletins(:two)

    params = { bulletin: { state_event: :archive } }
    patch admin_bulletin_path(bulletin), params: params
    assert bulletin.reload.archived?
  end
end
