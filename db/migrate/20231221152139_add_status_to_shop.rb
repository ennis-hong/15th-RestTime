class AddStatusToShop < ActiveRecord::Migration[7.1]
  def change
    add_column :shops, :status, :string 
  end
end
