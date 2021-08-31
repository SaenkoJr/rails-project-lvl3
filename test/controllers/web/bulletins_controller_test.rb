# frozen_string_literal: true

require 'test_helper'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulletin = bulletins(:one)
  end

  test '#new' do
    get new_bulletin_path
    assert_response :success
  end

  test '#show' do
    get bulletin_path @bulletin
    assert_response :success
  end

  test '#edit' do
    get edit_bulletin_path @bulletin
    assert_response :success
  end

  test '#create (signed in user)' do
    user = sign_in_as(:one)
    category = categories(:one)

    bulletin_attrs = {
      name: Faker::Lorem.sentence(word_count: 2),
      descrtiption: Faker::Lorem.sentence(word_count: 5),
      photo: fixture_file_upload('image1.jpeg', 'image/jpeg'),
      category_id: category.id
    }

    assert_difference('Bulletin.count', +1) do
      post bulletins_path, params: {
        bulletin: bulletin_attrs
      }
    end

    bulletin = Bulletin.last
    assert_equal bulletin.name, bulletin_attrs[:name]
    assert_equal bulletin.category, category
    assert_equal bulletin.author, user
  end

  test '#update (signed in user)' do
    sign_in_as(:one)

    new_category = categories(:two)
    bulletin_attrs = {
      name: Faker::Lorem.sentence(word_count: 2),
      descrtiption: Faker::Lorem.sentence(word_count: 5),
      category_id: new_category.id
    }

    patch bulletin_path @bulletin, params: { bulletin: bulletin_attrs }

    @bulletin.reload
    assert_equal @bulletin.name, bulletin_attrs[:name]
    assert_equal @bulletin.category, new_category
  end

  test '#destroy (signed in user)' do
    assert_difference('Bulletin.count', -1) do
      delete bulletin_path @bulletin
    end
  end
end
