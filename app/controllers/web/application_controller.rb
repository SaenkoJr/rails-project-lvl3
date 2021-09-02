# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  RANSACK_DEFATUL_SORT = 'created_at DESC'

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def page
    params.fetch(:page, 1)
  end

  def per_page
    params.fetch(:per_page, 10)
  end

  def ransack_params
    params.fetch(:q, { s: RANSACK_DEFATUL_SORT })
  end

  def user_not_authorized
    redirect_to root_path
  end
end
