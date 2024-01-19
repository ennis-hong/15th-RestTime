# frozen_string_literal: true

module ProductsHelper
  def product_cover(product, variant = :thumb)
    if product.cover.attached?
      image_tag product.cover.variant(variant), class: 'w-full h-full object-cover'
    else
      image_tag 'products/default.jpeg', class: 'w-full h-full object-cover'
    end
  end
end
