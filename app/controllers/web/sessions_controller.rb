# frozen_string_literal: true

class Web::SessionsController < Web::ApplicationController
  def new
    @user = User.new
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

  def auth_hash
    request.env['omniauth.auth']
  end

  def sign_in_params
    params.require(:user).permit(:email, :password)
  end
end
