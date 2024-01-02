# frozen_string_literal: true

module ApplicationHelper
  def county_options
    [
      %w[基隆市 基隆市],
      %w[臺北市 臺北市],
      %w[新北市 新北市],
      %w[桃園市 桃園市],
      %w[新竹市 新竹市],
      %w[新竹縣 新竹縣],
      %w[苗栗縣 苗栗縣],
      %w[臺中市 臺中市],
      %w[彰化縣 彰化縣],
      %w[南投縣 南投縣],
      %w[雲林縣 雲林縣],
      %w[嘉義市 嘉義市],
      %w[嘉義縣 嘉義縣],
      %w[臺南市 臺南市],
      %w[高雄市 高雄市],
      %w[屏東縣 屏東縣],
      %w[臺東縣 臺東縣],
      %w[花蓮縣 花蓮縣],
      %w[澎湖縣 澎湖縣],
      %w[金門縣 金門縣],
      %w[連江縣 連江縣]
    ].freeze
  end

  def format_time_without_sec(date_time)
    date_time&.strftime('%H:%M')
  end

  def format_date(date_time)
    date_time&.strftime('%Y/%m/%d')
  end

  def format_datetime(date_time)
    date_time&.strftime('%Y/%m/%d %H:%M')
  end

  def display_errors(any_model)
    return unless any_model.errors.any?

    content_tag(:div, class: 'bg-red-500 text-white p-4 mb-4') do
      content_tag(:ul) do
        any_model.errors.full_messages.map { |message| content_tag(:li, message) }.join.html_safe
      end
    end
  end

  def format_price(price)
    price.to_i.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\\1,')
  end

  def format_end_time(service_date, service_min)
    start_time = service_date.is_a?(String) ? DateTime.parse(service_date) : service_date
    end_time = start_time + service_min.minutes
    format_datetime(end_time)
  end

  def address(shop)
    "#{shop.city}#{shop.district}#{shop.street}"
  end
end
