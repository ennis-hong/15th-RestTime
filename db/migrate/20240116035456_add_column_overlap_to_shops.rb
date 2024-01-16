class AddColumnOverlapToShops < ActiveRecord::Migration[7.1]
  def change
    add_column :shops, :overlap, :integer, null: false,  default: 1
  end
end
