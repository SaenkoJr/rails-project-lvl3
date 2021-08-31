# frozen_string_literal: true

class Web::HomeController < Web::ApplicationController
  def index
    @bulletins = Bulletin.includes(:author).order(created_at: :desc)
  end
end
