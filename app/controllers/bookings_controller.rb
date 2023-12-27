# frozen_string_literal: true

class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_product, only: [:create]

  def checkout
    @order = Order.new
  end

  def create
    current_booking&.destroy
    current_user.create_booking(product: @product, service_date: params[:service_date])
    redirect_to checkout_booking_path
  end

  private

  def booking_params
    params.permit(:service_date, :product_id)
  end

  def find_product
    @product = Product.find(params[:product_id])
  end
end
