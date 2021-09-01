# frozen_string_literal: true

class Web::PasswordsController < Web::ApplicationController
  after_action :verify_authorized

  def edit
    authorize :password, :edit?
    @form = User::PasswordForm.new user: current_user
  end

  def update
    authorize :password, :update?
    @form = User::PasswordForm.new(password_params, user: current_user)

    if @form.update
      redirect_to user_path current_user
    else
      render :edit
    end
  end

  private

  def password_params
    params.require(:user_password_form).permit(:old_password, :password, :password_confirmation)
  end
end
