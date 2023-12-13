class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.boolean :onsale, default: false
      t.datetime :deleted_at
      t.integer :store_id
      t.integer :position
      t.datetime :publish_date

      t.timestamps
    end
    add_index :products, :deleted_at, name: "index_products_on_deleted_at"
    add_index :products, :store_id, name: "index_products_on_store_id"
  end
end
