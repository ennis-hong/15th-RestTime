class RemoveStoreIdAndIndexFromProducts < ActiveRecord::Migration[7.1]
  def change
     remove_column :products, :store_id
     remove_index :products, name: "index_products_on_store_id", if_exists: true
  end
end
