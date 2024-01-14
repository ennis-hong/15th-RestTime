# frozen_string_literal: true

module Vendor
  class OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :find_order, only: %i[show confirm_redeem redeem]

    def my
      @orders = current_user.shop.orders.includes(:product)

      filter_by_date_range if params[:start_date].present? && params[:end_date].present?

      sort_by_product_title if params[:sort_by] == 'product_title'

      return unless params[:search].present?

      search_orders
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

    def filter_by_date_range
      start_date = params[:start_date]
      end_date = params[:end_date]
      @orders = @orders.where(service_date: start_date..end_date, status: 'paid')
    end

    def sort_by_product_title
      @orders = @orders.where(status: 'paid').joins(:product).order('products.title ASC')
    end

    def search_orders
      search_term = "%#{params[:search]}%"
      @orders = @orders.where('serial LIKE ? OR booked_name LIKE ?', search_term, search_term)
    end
  end
end
