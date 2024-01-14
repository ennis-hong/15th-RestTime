class BookingService
  def initialize(service_times = {}, bookings = [])
    @service_times = service_times
    @bookings = bookings
  end

  # 生成指定日期所有預約時段
  def generate_time_slots(date)
    slots = []
    day_of_week = Date::DAYNAMES[date.wday]
    service_time = @service_times.find {|service_time| day_of_week == service_time.day_of_week}
    open_time = service_time.open_time
    close_time = service_time.close_time

    start_time = Time.new(date.year, date.month, date.day, open_time.hour, open_time.min, 0)
    end_time = Time.new(date.year, date.month, date.day, close_time.hour, close_time.min, 0) - 30.minutes
    while start_time < end_time
      slots << start_time
      start_time += 15.minutes # 每隔15分鐘
    end

    slots
  end

  # 返回可預定時段
  def available_slots(date)
    all_slots = generate_time_slots(date)
    available_slots = all_slots.select do |slot|
      overlapping_booking = @bookings.count do |booking|
        booking[:service_date].to_date == date.to_date &&
        booking[:service_date] <= slot &&
        booking[:service_date] + booking[:service_min].minutes > slot
      end
      overlapping_booking < 3
    end

    available_slots
  end

  # 簡化用於顯示時分
  def display_available_slots(date)
    available_slots(date).map { |slot| slot.strftime('%H:%M') }
  end
end
