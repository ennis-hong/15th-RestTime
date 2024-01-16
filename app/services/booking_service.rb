# frozen_string_literal: true

class BookingService
  def initialize(shop, product)
    @shop = shop
    @service_times = shop.service_times
    @bookings = shop.orders.valid
    @product = product
  end


  # 生成指定日期所有預約時段
  def generate_time_slots(date)
    slots = []
    day_of_week = Date::DAYNAMES[date.wday]
    service_time = @service_times.find { |service| day_of_week == service.day_of_week }
    open_time = service_time.open_time
    close_time = service_time.close_time

    service_minutes = @product&.service_min&.minutes || 30.minutes

    start_time = Time.new(date.year, date.month, date.day, open_time.hour, open_time.min, 0)
    end_time = Time.new(date.year, date.month, date.day, close_time.hour, close_time.min,
                        0) - service_minutes
    while start_time < end_time
      slots << start_time
      start_time += 15.minutes # 每隔15分鐘
    end

    slots
  end

  # 返回可預定時段
  def available_slots(date)
    all_slots = generate_time_slots(date)
    all_slots.select do |slot|
      overlapping_booking = @bookings.count do |booking|
        booking[:service_date].to_date == date.to_date &&
          booking[:service_date] <= slot &&
          booking[:service_date] + booking[:service_min].minutes > slot
      end
      overlapping_booking < @product.shop.overlap
    end
  end

  # 簡化用於顯示時分
  def display_available_slots(date)
    available_slots(date).map { |slot| slot.strftime('%H:%M') }
  end

  def available_booking?(date)
    available_slots(date).include?(date)
  end
end
