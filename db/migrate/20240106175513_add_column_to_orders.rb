class AddColumnToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :trade_no, :string
    remove_column :orders, :booking_date
  end
end
