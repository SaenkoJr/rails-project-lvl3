# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  skip_before_action :verify_authenticity_token, only: :callback

  def callback
    user = User.find_or_initialize_by(email: auth.info.email)

    unless user.persisted?
      user.last_name, user.first_name = auth.info.name.split
      user.save!
    end

    sign_in user
    redirect_to root_path, notice: t('.success')
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
