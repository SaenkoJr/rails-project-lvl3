# frozen_string_literal: true

class Web::Admin::HomeController < Web::Admin::ApplicationController
  def index
    @q = User.ransack(ransack_params.merge({ s: 'email ASC' }))
    @users = @q.result
               .page(page)
               .per(per_page)
  end
end
