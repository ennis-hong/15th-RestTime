# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :order_params, only: :create
  before_action :find_order, only: :show

  def my
    @orders = current_user.orders
  end

  def show; end

  def create
    @order = current_user.orders.new(order_params)
    @order.service_date = current_booking.service_date
    @order.price = booking_product.price
    @order.service_min = booking_product.service_min

    if @order.save
      current_booking.destroy
      @order.confirm!
      redirect_to root_path, notice: t('message.Appointment Successful')
    else
      render 'bookings/checkout'
    end
  end

  private

  def order_params
    params.require(:order)
          .permit(:booked_name, :booked_email).merge(product: booking_product, shop: booking_shop)
  end

  def find_order
    @order = Order.find(params[:id])
  end
end
