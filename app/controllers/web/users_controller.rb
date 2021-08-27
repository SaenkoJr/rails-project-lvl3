# frozen_string_literal: true

class Web::UsersController < Web::ApplicationController
  before_action :set_user, only: %i[show update destroy]

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new user_params

    if @user.save
      sign_in(@user)
      redirect_to user_path
    else
      render :new
    end
  end

  def update
    if @user.update user_params
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path
  end

  private

  def set_user
    @user = User.find(session[:user_id])
  end

  def user_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
      :password,
      :password_confirmation
    )
  end
end
