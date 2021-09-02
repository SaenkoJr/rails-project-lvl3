# frozen_string_literal: true

require 'test_helper'

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulletin = bulletins(:one)
  end

  test '#index (as admin)' do
    sign_in_as :admin
    get admin_bulletins_path(@bulletin)
    assert_response :success
  end

  test '#index (non admin cant get index page)' do
    sign_in_as :one
    get admin_bulletins_path(@bulletin)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test '#edit (as admin)' do
    sign_in_as :admin
    get edit_admin_bulletin_path(@bulletin)
    assert_response :success
  end

  test '#edit (non admin cant get edit page)' do
    sign_in_as :one
    get edit_admin_bulletin_path(@bulletin)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test '#update (as admin)' do
    sign_in_as :admin

    bulletin_attrs = {
      name: 'updated name',
      description: 'updated description'
    }

    patch admin_bulletin_path(@bulletin), params: {
      bulletin: bulletin_attrs
    }

    @bulletin.reload
    assert_response :redirect
    assert_equal @bulletin.name, bulletin_attrs[:name]
    assert_equal @bulletin.description, bulletin_attrs[:description]
  end

  test '#update (non admin cant update user)' do
    sign_in_as :one

    old_name = @bulletin.name
    bulletin_attrs = {
      name: 'updated name',
      description: 'updated description'
    }

    patch admin_bulletin_path(@bulletin), params: {
      bulletin: bulletin_attrs
    }

    @bulletin.reload
    assert_equal @bulletin.name, old_name
    assert_response :redirect
    assert_redirected_to root_path
  end

  test '#destroy (as admin)' do
    sign_in_as :admin

    assert_difference('Bulletin.count', -1) do
      delete admin_bulletin_path(@bulletin)
    end
  end

  test '#destroy (non admin cant delete user)' do
    sign_in_as :one

    assert_no_difference('Bulletin.count') do
      delete admin_bulletin_path(@bulletin)
    end

    assert_response :redirect
    assert_redirected_to root_path
  end

  test 'publish from moderation' do
    sign_in_as :admin
    bulletin = bulletins(:without_description)

    params = { bulletin: { status_event: :publish } }
    patch admin_bulletin_path(bulletin), params: params
    assert bulletin.reload.published?
  end
end
