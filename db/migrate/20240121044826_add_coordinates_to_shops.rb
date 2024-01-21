class AddCoordinatesToShops < ActiveRecord::Migration[7.1]
  def change
    add_column :shops, :latitude, :float
    add_index :shops, :latitude
    add_column :shops, :longitude, :float
    add_index :shops, :longitude
  end
end
