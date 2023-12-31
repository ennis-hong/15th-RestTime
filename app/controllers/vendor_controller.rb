# frozen_string_literal: true

class VendorController < ApplicationController
  before_action :find_owned_shop, only: %i[edit show update destroy]

  # 搜尋修改後
  def index
    authorize Shop, :index?
    @shop = current_user&.shop
    @q = Shop.ransack(params[:q])
    @shops = @q.result(distinct: true).order(order_by).page(params[:page]).per(8)
  end

  def new
    authorize Shop, :new?
    @shop = Shop.new
  end

  def create
    authorize Shop, :create?
    @shop = current_user.build_shop(shop_params)
    if @shop.save
      redirect_to shop_path(@shop), notice: t(:list_your_services_products, scope: %i[views shop message])
    else
      render :new
    end
  end

  def edit
    authorize @shop, :edit?
  end

  def show
    authorize @shop, :show?
  end

  def update
    authorize @shop, :update?
    if @shop.update(shop_params)
      redirect_to shop_path, notice: t(:updated, scope: %i[views shop message])
    else
      render :edit
    end
  end

  def destroy
    authorize @shop, :destroy?
  end

  private

  def shop_params
    params.require(:shop).permit(:title, :tel, :description, :city, :district, :street, :contact, :contactphone,
                                 :cover, :status)
  end

  def find_owned_shop
    @shop = current_user.shop
  end

  # 搜尋新增
  def order_by
    order_options = {
      'city desc' => 'city desc',
      'updated_at desc' => 'updated_at desc'
    }

    selected_option = params.dig(:q, :s)
    order_options[selected_option] || 'city desc'
  end

  def check_ownership
    return unless current_user == @shop

    redirect_to root_path, alert: t(:wrong_way, scope: %i[views shop message])
  end
end
