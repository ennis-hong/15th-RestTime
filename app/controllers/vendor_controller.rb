# frozen_string_literal: true

class VendorController < ApplicationController
  before_action :find_owned_shop, only: %i[edit show update destroy]

  # 搜尋修改後

  def index
    authorize :shop
    @shop = current_user&.shop
  end

  def new
    @shop = Shop.new
    authorize @shop
  end

  def my
    @orders = Order.where(
      service_date: Time.now.beginning_of_month.beginning_of_week..Time.now.end_of_month.end_of_week
    )
  end

  def create
    authorize :shop
    @shop = current_user.build_shop(shop_params)
    if @shop.save
      redirect_to shop_path(@shop), notice: t('create_shop_success', scope: %i[views shop message])
    else
      render :new
    end
  end

  def edit
    authorize @shop
  end

  def show
    authorize @shop
  end

  def update
    authorize @shop
    if @shop.update(shop_params)
      redirect_to shop_path, notice: t(:updated, scope: %i[views shop message])
    else
      flash.now[:alert] = '更新商店資訊時發生錯誤'
      render :edit
    end
  end

  def destroy
    authorize @shop
  end

  private

  def shop_params
    params.require(:shop).permit(:title, :tel, :description,
                                 :city, :district, :street,
                                 :contact, :contactphone,
                                 :cover, :status)
  end

  def find_owned_shop
    @shop = current_user.shop
  end

  def check_ownership
    return unless current_user == @shop

    redirect_to root_path, alert: t(:wrong_way, scope: %i[views shop message])
  end
end
