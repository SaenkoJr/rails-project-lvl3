# frozen_string_literal: true

class Web::Users::ProfilesController < Web::ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  after_action :verify_authorized

  def show
    authorize @user
    @q = @user.bulletins.ransack(ransack_params)
    @bulletins = @q.result
                   .includes(:category)
                   .page(page)
                   .per(per_page)
    @categories = Category.all
    @states = Bulletin.aasm(:state).states
  end

  def edit
    authorize @user
  end

  def update
    authorize @user

    if @user.update user_params
      redirect_to profile_path, notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    authorize @user

    @user.destroy
    sign_out
    redirect_to root_path, notice: t('.success')
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name
    )
  end
end
