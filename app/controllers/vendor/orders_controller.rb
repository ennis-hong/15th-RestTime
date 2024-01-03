# frozen_string_literal: true

module Vendor
  class OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :find_order, only: %i[show confirm_redeem redeem]

    def my
      if current_user&.shop.present?
        @orders = current_user.shop.orders.includes(:user).order(id: :desc)
      else
        redirect_to root_path, alert: t('wrong way', scope: %i[views shop message])
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
        redirect_to my_vendor_orders_path, notice: t('order has been redeemed', scope: %i[message])
      else
        redirect_to @order, alert: t('order can not redeem', scope: %i[message])
      end
    end

    private

    def find_order
      @order = Order.find(params[:id])
    end
  end
end
