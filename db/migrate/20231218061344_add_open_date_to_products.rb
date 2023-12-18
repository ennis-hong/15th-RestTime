class AddOpenDateToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :service_hour, :integer
  end
end
