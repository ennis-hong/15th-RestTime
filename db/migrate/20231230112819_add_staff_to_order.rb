class AddStaffToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :staff, :string 
  end
end
