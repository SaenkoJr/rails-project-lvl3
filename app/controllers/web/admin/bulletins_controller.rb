# frozen_string_literal: true

class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  before_action :set_bulletin, only: %i[edit update publish reject archive]

  def index
    @q = Bulletin.ransack(ransack_params)
    @bulletins = @q.result
                   .includes(%i[user category])
                   .page(page)
                   .per(per_page)
    @categories = Category.all
    @states = Bulletin.aasm(:state)
                      .states
  end

  def edit; end

  def update
    if @bulletin.update bulletin_params
      redirect_to edit_admin_bulletin_path(@bulletin), notice: t('.success')
    else
      render :edit, alert: t('.failed')
    end
  end

  def publish
    if @bulletin.may_publish?
      @bulletin.publish!
      redirect_back(fallback_location: edit_admin_bulletin_path(@bulletin), notice: t('.success'))
    else
      redirect_to edit_admin_bulletin_path(@bulletin), alert: t('.failed')
    end
  end

  def reject
    if @bulletin.may_reject?
      @bulletin.reject!
      redirect_back(fallback_location: edit_admin_bulletin_path(@bulletin), notice: t('.success'))
    else
      redirect_to edit_admin_bulletin_path(@bulletin), alert: t('.failed')
    end
  end

  def archive
    if @bulletin.may_archive?
      @bulletin.archive!
      redirect_back(fallback_location: edit_admin_bulletin_path(@bulletin), notice: t('.success'))
    else
      redirect_to edit_admin_bulletin_path(@bulletin), alert: t('.failed')
    end
  end

  private

  def set_bulletin
    @bulletin = Bulletin.find(params[:id])
  end

  def bulletin_params
    params.require(:bulletin).permit(:title, :description, :category_id, :photo)
  end
end
