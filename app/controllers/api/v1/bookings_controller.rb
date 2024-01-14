module Api
  module V1
    class BookingsController < ApplicationController
      before_action :find_shop, only: [:available_slots]

      def available_slots
        bookingService = BookingService.new(@shop.service_times, @shop.orders.where(service_date: params[:booking_date].to_date.beginning_of_day..params[:booking_date].to_date.end_of_day))
        available_slots = bookingService.display_available_slots(Date.parse(params[:booking_date], '%Y/%m/%d %H:%M'))
        render json: { available_slots: available_slots }
      end

      private

      def find_shop
        @shop = Shop.find(params[:id])
      end
    end
  end
end
