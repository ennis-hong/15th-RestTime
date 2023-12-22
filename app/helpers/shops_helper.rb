# frozen_string_literal: true

module ShopsHelper
  def shop_cover(shop, variant = :thumb)
    if shop.cover.attached?
      image_tag shop.cover.variant(variant), class: 'w-full h-full object-cover'
    else
      image_tag 'shops/default.png', class: 'w-full h-full object-cover'
    end
  end
end
