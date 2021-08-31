# frozen_string_literal: true

class Web::BulletinsController < ApplicationController
  before_action :set_bulletin, only: %i[show edit update destroy]

  def index
    @bulletins = Bulletin.includes(:author).order(created_at: :desc)
  end

  def new
    @bulletin = Bulletin.new
  end

  def show; end

  def edit; end

  def create
    @bulletin = current_user.bulletins.build bulletin_params

    if @bulletin.save
      redirect_to @bulletin
    else
      render :new
    end
  end

  def update
    if @bulletin.update bulletin_params
      redirect_to @bulletin
    else
      render :edit
    end
  end

  def destroy
    @bulletin.destroy

    redirect_to root_path
  end

  private

  def bulletin_params
    params.require(:bulletin).permit(:name, :description, :category_id, :photo)
  end

  def set_bulletin
    @bulletin = Bulletin.find(params[:id])
  end
end
