# frozen_string_literal: true

class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  before_action :set_bulletin, only: %i[edit update]

  def index
    @q = Bulletin.ransack(ransack_params)
    @bulletins = @q.result
                   .includes(%i[author category])
                   .page(page)
                   .per(per_page)
    @categories = Category.all
    @statuses = Bulletin.aasm(:status)
                        .states
                        .map(&:human_name)
  end

  def edit; end

  def update
    if @bulletin.update bulletin_params
      redirect_to edit_admin_bulletin_path(@bulletin), notice: t('.success')
    else
      render :edit, alert: t('.failed')
    end
  end

  private

  def set_bulletin
    @bulletin = Bulletin.find(params[:id])
  end

  def bulletin_params
    params.require(:bulletin).permit(:name, :description, :category_id, :photo, :status_event)
  end
end
