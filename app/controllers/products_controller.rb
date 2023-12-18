# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :find_product, only: %i[show edit update destroy]

  def index
    @products = Product.all.order(id: :desc)
  end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to root_path, notice: '新增商品成功'
    else
      render :new
    end
  end

  def edit; end

  def update
    # if @product.update(product_params)
    #   redirect_to product_path(@product), notice: '更新成功'
    # else
    #   render :edit
    # end
  end

  def destroy
    # find_product
    # @product.destroy
    # redirect_to root_path, notice: '商品已刪除'
  end

  def search; end

  private

  def find_product
    @product = Product.find(params[:id])
  end

  def find_owned_product
    @product = current_user.products.find(params[:id])
  end
end
