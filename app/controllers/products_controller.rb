# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :find_product, only: %i[show edit update destroy]
  before_action :find_owned_product, only: %i[edit update destroy show]

  def index
    authorize Product
    @q = Product.ransack(params[:q])
    @products = @q.result
                  .onsale
                  .order(order_by)
                  .page(params[:page])
  end

  def show
    authorize :product
    @shop = @product.shop
  end

  def my
    authorize :product
    @products = current_user.shop.products.page(params[:page])
  end

  def new
    @product = Product.new
    authorize @product
  end

  def create
    @product = current_user.shop.products.new(product_params)
    authorize @product
    if @product.save
      redirect_to my_products_path, notice: t('product.create_success')
    else
      render :new
    end
  end

  def edit
    authorize @product
  end

  def update
    authorize @product
    if @product.update(product_params)
      redirect_to my_products_path, notice: t('product.update_success')
    else
      render :edit
    end
  end

  def destroy
    authorize @product
    @product.destroy
    redirect_to my_products_path, notice: t('product.delete_success')
  end

  private

  def product_params
    params.require(:product)
          .permit(:title, :cover, :price, :description, :service_min, :onsale, :publish_date)
  end

  def find_product
    @product = Product.find(params[:id])
  end

  def find_owned_product
    @product = Product.unscope(where: :onsale)
                      .find(params[:id])
  end

  def order_by
    params.dig(:q, :s) || 'price asc'
  end
end
