# frozen_string_literal: true

require 'test_helper'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulletin = bulletins(:one)
  end

  test '#new (signed in user)' do
    sign_in_as(:one)
    get new_bulletin_path
    assert_response :success
  end

  test '#new (guest must be redirected to root path)' do
    get new_bulletin_path
    assert_response :redirect
    assert_redirected_to root_path
  end

  test '#show' do
    get bulletin_path @bulletin
    assert_response :success
  end

  test '#edit (signed in user)' do
    sign_in_as(:one)
    get edit_bulletin_path @bulletin
    assert_response :success
  end

  test '#edit (guest must be redirected to root path)' do
    get edit_bulletin_path @bulletin
    assert_response :redirect
    assert_redirected_to root_path
  end

  test '#create (signed in user)' do
    user = sign_in_as(:one)
    category = categories(:one)

    params = {
      moderate: true,
      bulletin: {
        name: Faker::Lorem.sentence(word_count: 2),
        descrtiption: Faker::Lorem.sentence(word_count: 5),
        photo: fixture_file_upload('image1.jpeg', 'image/jpeg'),
        category_id: category.id
      }
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
      bulletin: {
        name: Faker::Lorem.sentence(word_count: 2),
        category_id: category.id
      }
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

    bulletin_attrs = {
      name: Faker::Lorem.sentence(word_count: 2),
      descrtiption: Faker::Lorem.sentence(word_count: 5),
      photo: fixture_file_upload('image1.jpeg', 'image/jpeg'),
      category_id: category.id
    }

    post bulletins_path, params: {
      bulletin: bulletin_attrs
    }

    assert_response :redirect
    assert_redirected_to root_path
  end

  test '#update (only author can update)' do
    sign_in_as(:one)

    new_category = categories(:two)
    params = {
      moderate: true,
      bulletin: {
        name: Faker::Lorem.sentence(word_count: 2),
        descrtiption: Faker::Lorem.sentence(word_count: 5),
        category_id: new_category.id
      }
    }

    patch bulletin_path @bulletin, params: params

    @bulletin.reload
    assert_equal @bulletin.name, params[:bulletin][:name]
    assert_equal @bulletin.category, new_category
    assert @bulletin.on_moderate?
  end

  test '#update (guest must be redirected to root path)' do
    bulletin_attrs = {
      name: Faker::Lorem.sentence(word_count: 2)
    }

    patch bulletin_path @bulletin, params: { bulletin: bulletin_attrs }

    assert_response :redirect
    assert_redirected_to root_path
  end

  test '#destroy (only author can delete)' do
    sign_in_as :one
    assert_difference('Bulletin.count', -1) do
      delete bulletin_path @bulletin
    end
  end

  test '#destroy (guest must be redirected to root path)' do
    delete bulletin_path @bulletin

    assert_response :redirect
    assert_redirected_to root_path
  end
end
