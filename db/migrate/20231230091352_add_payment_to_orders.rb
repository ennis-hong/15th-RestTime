class AddPaymentToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :payment_date, :datetime
    add_column :orders, :payment_type, :string
    add_column :orders, :payment_type_charge_fee, :string
    add_column :orders, :rtn_code, :string
    add_column :orders, :rtn_msg, :string
  end
end
