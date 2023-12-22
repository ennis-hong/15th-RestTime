module ProductsHelper
  def product_cover(product, variant = :thumb)
    if product.cover.attached?
      image_tag product.cover.variant(variant)
    else
      image_tag 'products/default.jpeg'
    end
  end
end
