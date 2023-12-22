class AddShopToProduct < ActiveRecord::Migration[7.1]
  def change
    add_reference :products, :shop, foreign_key: true, index: true
  end
end
