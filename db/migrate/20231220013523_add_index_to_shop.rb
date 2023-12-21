class AddIndexToShop < ActiveRecord::Migration[7.1]
  def change
    add_index :shops, :deleted_at
    add_column :shops, :contact, :string 
    add_column :shops, :contactphone, :string 
  end
end
