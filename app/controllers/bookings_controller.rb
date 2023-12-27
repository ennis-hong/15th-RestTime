# frozen_string_literal: true

class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_product, only: [:create]

  def show; end

  def checkout
    @order = Order.new
  end

  def create
    current_booking
    redirect_to checkout_booking_path
  end

  def destroy
    current_booking.destroy
  end

  private

  def find_product
    @product = Product.find(params[:product_id])
  end
end
