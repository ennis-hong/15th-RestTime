# frozen_string_literal: true

module Api
  module V1
    class BookingsController < ApplicationController
      before_action :find_shop, only: [:available_slots]

      def available_slots
        range = params[:booking_date].to_date.beginning_of_day..params[:booking_date].to_date.end_of_day
        booking_service = BookingService.new(@shop.service_times,
                                             @shop.orders.where(service_date: range))
        available_slots = booking_service.display_available_slots(Date.parse(params[:booking_date], '%Y/%m/%d %H:%M'))
        render json: { available_slots: }
      end

      private

      def find_shop
        @shop = Shop.find(params[:id])
      end
    end
  end
end
