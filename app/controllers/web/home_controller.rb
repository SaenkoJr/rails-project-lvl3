# frozen_string_literal: true

class Web::HomeController < Web::ApplicationController
  def index
    @q = Bulletin.published.ransack(ransack_params)
    @bulletins = @q.result
                   .includes(%i[author category])
                   .page(page)
                   .per(per_page)
    @categories = Category.all
  end
end
