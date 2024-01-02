class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_order, only: %i[show]

  def index
    if current_user&.shop.present?
      @orders = current_user.shop.orders.includes(:user).order(id: :desc)
    else
      redirect_to root_path, alert: t(:wrong_way, scope: %i[views shop message])
    end
  end

  def show
    @shop = @order.shop
  end

  private

  def find_order
    @order = Order.find(params[:id])
  end
  
end
