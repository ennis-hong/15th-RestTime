# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :find_product, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_owned_product, only: %i[edit update destroy]

  def index
    authorize Product
    @q = Product.ransack(params[:q])
    @products = @q.result
                  .where(onsale: true)
                  .order(order_by)
                  .page(params[:page])
                  .per(8)
  end

  def show
    authorize Product
  end

  def my
    authorize Product
    @products = current_user_shop.first.products
                                 .unscope(where: :onsale)
                                 .page(params[:page])
                                 .per(8)
  end

  def new
    authorize Product
    @product = Product.new
  end

  def create
    authorize Product
    @product = current_user.shop.products.new(product_params)

    if @product.save
      redirect_to my_products_path, notice: '商品創建成功'
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
      redirect_to my_products_path, notice: '更新成功'
    else
      render :edit
    end
  end

  def destroy
    authorize @product
    @product.destroy
    redirect_to my_products_path, notice: '商品已刪除'
  end

  def search
    authorize Product
    @products = Product.ransack(title_cont: params[:q]).result
  end

  private

  def product_params
    params.require(:product)
          .permit(:title, :cover, :price, :description, :service_min, :onsale, :publish_date, :shop_id)
  end

  def find_product
    @product = Product.find(params[:id])
  end

  def find_owned_product
    @product = Product.unscope(where: :onsale)
                      .find(params[:id])
  end

  def order_by
    order_options = {
      'price desc' => 'price desc',
      'service_min desc' => 'service_min desc',
      'created_at desc' => 'created_at desc',
      'updated_at desc' => 'updated_at desc'
    }

    selected_option = params.dig(:q, :s)
    order_options[selected_option] || 'price desc'
  end
end
