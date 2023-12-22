class AddColumnShops < ActiveRecord::Migration[7.1]
  def change
    add_column :shops, :city, :string
    add_column :shops, :district, :string
    add_column :shops, :street, :text
    add_reference :shops, :user, foreign_key: true
  end
end
