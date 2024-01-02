class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :order_params, only: :create
  before_action :find_order, only: %i[show confirm_redeem redeem]

  def index
    if current_user&.shop.present?
      @orders = current_user.shop.orders.includes(:user).order(id: :desc)
    else
      redirect_to root_path, alert: t('wrong way', scope: %i[views shop message])
    end
  end

  def show
    @shop = @order.shop
  end

  def create
    @order = current_user.orders.new(order_params)
    @order.service_date = current_booking.service_date
    @order.price = booking_product.price
    @order.service_min = booking_product.service_min

    if @order.save
      current_booking.destroy
      @order.confirm!
      redirect_to root_path, notice: t('message.appointment successful')
    else
      render 'bookings/checkout'
    end
  end

  def confirm_redeem
    authorize @order, :access_page?
    @status = params[:status]
    @staff = params[:staff]
  end

  def redeem
    @order.completed?
    if @order.update(status: params[:status], staff: params[:staff])
      redirect_to admin_orders_path, notice: t('order has been redeemed', scope: %i[message])
    else
      redirect_to @order, alert: t('order can not redeem', scope: %i[message])
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
