# frozen_string_literal: true

module Api
  module V1
    class BookingsController < ApplicationController
      before_action :find_shop, only: [:available_slots]

      def available_slots
        date_range = params[:booking_date].to_date.beginning_of_day..params[:booking_date].to_date.end_of_day
        orders = @shop.orders.where(service_date: date_range)
                      .where.not(status: %i[completed cancelled])
        booking_service = BookingService.new(@shop.service_times,
                                             orders,
                                             @shop.products.find_by(id: params[:product]))
        available_slots = booking_service.display_available_slots(DateTime.parse(params[:booking_date],
                                                                                 '%Y/%m/%d %H:%M'))
        render json: { available_slots: }
      end

      private

      def find_shop
        @shop = Shop.find(params[:id])
      end
    end
  end
end
