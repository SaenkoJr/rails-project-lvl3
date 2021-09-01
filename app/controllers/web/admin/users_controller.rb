# frozen_string_literal: true

class Web::Admin::UsersController < Web::Admin::ApplicationController
  before_action :set_user, only: %i[edit update destroy]

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admin_root_path
    else
      render :edit
    end
  end

  def destroy
    @user.destroy

    redirect_to admin_root_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name)
  end
end
