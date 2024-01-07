# frozen_string_literal: true

module OrdersHelper
  def booking_end_time(booking)
    end_time = booking.service_date + booking.product.service_min.minutes
    format_time_without_sec(end_time)
  end

  def render_steps(order)
    render "#{order.status}"
  end
end
