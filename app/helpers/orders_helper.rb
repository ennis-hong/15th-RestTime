# frozen_string_literal: true

module OrdersHelper
  def booking_end_time(booking)
    end_time = booking.service_date + booking.product.service_min.minutes
    format_time_without_sec(end_time)
  end

  def render_steps(order)
    render order.status.to_s
  end

  def tag_color(order)
    case order.status
    when 'cancelled'
      'bg-red-500 text-white rounded p-1 text-sm mb-1'
    when 'paid'
      'bg-yellow-400 text-white rounded p-1 text-sm mb-1'
    when 'completed'
      'bg-slate-500 text-white rounded p-1 text-sm mb-1'
    else
      'bg-blue-400 text-white rounded p-1 text-sm mb-1'
    end
  end
end
