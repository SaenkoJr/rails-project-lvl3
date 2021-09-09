# frozen_string_literal: true

require 'test_helper'

class Web::Admin::HomeControllerTest < ActionDispatch::IntegrationTest
  test '#index (admin)' do
    sign_in_as :admin
    get admin_root_path
    assert_response :success
  end

  test '#index (non admin cant get index page)' do
    get admin_root_path
    assert_redirected_to root_path
  end
end
