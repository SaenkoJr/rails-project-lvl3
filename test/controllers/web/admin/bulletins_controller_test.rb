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

  test 'publish bulletin (non admin cant aprove)' do
    bulletin = bulletins(:under_moderation)

    patch publish_admin_bulletin_path bulletin

    assert bulletin.reload.under_moderation?
    assert_redirected_to root_path
  end

  test 'publish bulletin (as admin)' do
    sign_in_as_with_github :admin
    bulletin = bulletins(:under_moderation)

    patch publish_admin_bulletin_path bulletin
    assert bulletin.reload.published?
  end

  test 'reject bulletin (non admin cant reject)' do
    bulletin = bulletins(:under_moderation)

    patch reject_admin_bulletin_path bulletin

    assert bulletin.reload.under_moderation?
    assert_redirected_to root_path
  end

  test 'reject bulletin (as admin)' do
    sign_in_as_with_github :admin
    bulletin = bulletins(:under_moderation)

    patch reject_admin_bulletin_path bulletin

    assert bulletin.reload.rejected?
  end

  test 'archive bulletin (non admin cant archive)' do
    bulletin = bulletins(:under_moderation)

    patch archive_admin_bulletin_path bulletin

    assert bulletin.reload.under_moderation?
    assert_redirected_to root_path
  end

  test 'archive bulletin (as admin)' do
    sign_in_as_with_github :admin
    bulletin = bulletins(:two)

    patch archive_admin_bulletin_path bulletin
    assert bulletin.reload.archived?
  end
end
