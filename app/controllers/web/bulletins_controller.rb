# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :set_bulletin, only: %i[show edit update archive]

  after_action :verify_authorized, except: %i[index show]

  def index
    @q = Bulletin.published.ransack(ransack_params)
    @bulletins = @q.result
                   .includes(%i[user category])
                   .page(page)
                   .per(per_page)
    @categories = Category.all
  end

  def new
    @bulletin = Bulletin.new

    authorize @bulletin
  end

  def show; end

  def edit
    authorize @bulletin
  end

  def create
    authorize Bulletin

    @bulletin = current_user.bulletins.build bulletin_params
    change_state(@bulletin)

    if @bulletin.save
      redirect_to @bulletin, notice: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @bulletin

    change_state(@bulletin)
    if @bulletin.update bulletin_params
      redirect_to @bulletin, notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def archive
    authorize @bulletin

    if @bulletin.may_archive?
      @bulletin.archive!
      redirect_to @bulletin, notice: t('.success')
    else
      redirect_to @bulletin, status: :unprocessable_entity
    end
  end

  private

  def change_state(bulletin)
    bulletin.send_to_moderate if params[:moderate]
    bulletin.make_draft if params[:make_draft]
  end

  def bulletin_params
    params.require(:bulletin).permit(:title, :description, :category_id, :photo)
  end

  def set_bulletin
    @bulletin = Bulletin.find(params[:id])
  end
end
