# frozen_string_literal: true

class Web::Admin::BulletinsController < ApplicationController
  before_action :set_bulletin, only: %i[edit update destroy]

  def index
    @bulletins = Bulletin.all
  end

  def edit; end

  def update
    if @bulletin.update bulletin_params
      redirect_to admin_bulletins_path
    else
      render :edit
    end
  end

  def destroy
    @bulletin.destroy

    redirect_to admin_bulletins_path
  end

  private

  def set_bulletin
    @bulletin = Bulletin.find(params[:id])
  end

  def bulletin_params
    params.require(:bulletin).permit(:name, :description, :category_id, :photo)
  end
end
