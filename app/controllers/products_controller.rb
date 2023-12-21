# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :find_product, only: %i[show edit update destroy]

  def index
    @products = Product.order(id: :desc)
                       .page(params[:page])
                       .per(8)
  end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: '新增商品成功'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to product_path(@product), notice: '更新成功'
    else
      render :edit
    end
  end

  def destroy
    return unless @product.destroy

    redirect_to root_path, notice: '商品已刪除'
  end

  def search
    data = Product.ransack(title_cont: params[:q])
    @products = data.result
  end

  private

  def product_params
    params.require(:product)
          .permit(:title, :cover, :price, :description, :service_time, :onsale)
  end

  def find_product
    @product = Product.find(params[:id])
  end
end
