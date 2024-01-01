# frozen_string_literal: true
class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :order_params, only: :create
  before_action :find_order, only: %i[show confirm_status update_status]

  def my
    @orders = current_user.orders
  end

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

  def show
    @shop = @order.shop
    @url_string = confirm_status_order_url(@order, status: 'completed', host: request.host_with_port)
  end

  def confirm_status
    authorize @order, :access_page?
    @status = params[:status]
    @staff = params[:staff]
  end

  def update_status
    @order.completed?
    if @order.update(status: params[:status], staff: params[:staff])
      redirect_to @order, notice: t(:Order_has_been_redeemed, scope: %i[message])
      # redirect_to vendor_order_path 之後設定前往管理頁面
    else
      redirect_to @order, alert: t(:Order_can_not_redeem, scope: %i[message])
    end
  end

  private

  def order_params
    params.require(:order)
          .permit(:booked_name, :booked_email, :staff).merge(product: booking_product, shop: booking_shop)
  end

  def find_order
    @order = Order.find(params[:id])
  end
end
