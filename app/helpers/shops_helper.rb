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
end
