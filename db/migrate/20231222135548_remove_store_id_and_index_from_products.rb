class RemoveStoreIdAndIndexFromProducts < ActiveRecord::Migration[7.1]
  def change
     # 移除 products 表上的 store_id 列
     remove_column :products, :store_id
     # 移除索引
     remove_index :products, name: "index_products_on_store_id", if_exists: true
  end
end
