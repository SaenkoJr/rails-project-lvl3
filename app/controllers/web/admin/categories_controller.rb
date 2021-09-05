# frozen_string_literal: true

class Web::Admin::CategoriesController < Web::Admin::ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  def index
    @q = Category.ransack(ransack_params)
    @categories = @q.result
                    .page(page)
                    .per(per_page)
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = Category.new category_params

    if @category.save
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def update
    if @category.update category_params
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    @category.destroy

    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
