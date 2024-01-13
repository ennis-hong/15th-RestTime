# frozen_string_literal: true

module Vendor
  class OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :find_order, only: %i[show confirm_redeem redeem]

    def my
      @orders = current_user.shop.orders.includes(:order, :product).order(id: :desc)

      @orders = if params[:status].present?
                  Order.where(status: params[:status]).order(created_at: :desc)
                else
                  Order.order(created_at: :desc)
                end
    end

    def show
      @shop = @order.shop
    end

    def confirm_redeem
      authorize @order, :access_page?
    end

    def redeem
      if @order.may_complete?
        @order.complete!
        @order.update(staff: params[:staff])
        redirect_to my_vendor_orders_path, notice: t('order_has_been_redeemed', scope: %i[message])
        OrderMailer.redeem_order_email_to_general(@order).deliver_later
        OrderMailer.redeem_order_email_to_vendor(@order).deliver_later
      else
        redirect_to @order, alert: t('order_can_not_redeem', scope: %i[message])
      end
    end

    private

    def find_order
      @order = Order.find(params[:id])
    end
  end
end
