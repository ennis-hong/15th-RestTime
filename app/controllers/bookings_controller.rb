# frozen_string_literal: true

class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_product, only: [:create]

  def create
    current_booking.update(product: @product, service_date: params[:service_date])
    redirect_to new_order_path
  end

  private

  def find_product
    @product = Product.find(params[:product_id])
  end
end
