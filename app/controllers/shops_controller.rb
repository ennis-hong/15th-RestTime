# frozen_string_literal: true

class ShopsController < ApplicationController
  before_action :find_shop, only: %i[show]
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_owned_shop, only: %i[edit update destroy]

  def index
    # @shop = current_user.shop
    @shops = Shop.order(id: :desc).page(params[:page]).per(8)
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = current_user.build_shop(shop_params)
    if @shop.save
      redirect_to shop_path(@shop), notice: '店家建立成功'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @shop.update(shop_params)
      redirect_to shop_path, notice: '店家資訊更新成功'
    else
      render :edit
    end
  end

  def destroy
    @shop.destroy
    redirect_to shops_path, alert: '店家資訊已刪除'
  end

  private

  def shop_params
    params.require(:shop).permit(:title, :tel, :description, :city, :district, :street, :contact, :contactphone, :cover, :status)
  end

  def find_shop
    @shop = Shop.find(params[:id])
  end

  def find_owned_shop
    @shop = current_user.shop
  end
end
