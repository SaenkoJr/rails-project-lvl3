# frozen_string_literal: true

class Web::SessionsController < Web::ApplicationController
  def new
    @user = User.new
  end

  def callback
    user = User.find_or_initialize_by(email: auth.info.email)

    unless user.persisted?
      user.last_name, user.first_name = auth.info.name.split
      user.password = BCrypt::Password.create ENV['SECRET_PASSWORD']
      user.save!
    end

    sign_in user
    redirect_to user
  end

  def create
    user = User.find_by(email: sign_in_params[:email])

    if user&.authenticate(sign_in_params[:password])
      sign_in(user)
      redirect_to root_path
    else
      redirect_to new_session_path, notice: 'wrong'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end

  def sign_in_params
    params.require(:user).permit(:email, :password)
  end
end
