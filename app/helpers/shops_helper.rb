# frozen_string_literal: true

module ShopsHelper
  def shop_cover(shop, variant = :thumb)
    if shop.cover.attached?
      image_tag shop.cover.variant(variant), class: 'w-full h-full object-cover'
    else
      image_tag 'shops/default.png', class: 'w-full h-full object-cover'
    end
  end

  def address(shop)
    "#{shop.city}#{shop.district}#{shop.street}"
  end

  def shop_product_options(shop)
    shop.products.map do |product|
      ["#{product.title} | #{product.service_min} min | #{t('order.currency')} #{product.price.to_i}", product.id]
    end
  end

  def display_service_time(service_time)
    if service_time.off_day?
      t('service_times.off_day')
    else
      open_time = format_time_without_sec(service_time.open_time)
      close_time = format_time_without_sec(service_time.close_time)
      t('format', scope: %i[views shop show], open_time:, close_time:)
    end
  end
end
