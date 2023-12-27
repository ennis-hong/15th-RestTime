class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :status, default: 'pending'
      t.datetime :booking_date
      t.datetime :service_date
      t.string :serial
      t.decimal :price
      t.integer :quantitiy, default: 1
      t.integer :service_min
      t.string :booked_name
      t.string :booked_email, null: false
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :shop, null: false, foreign_key: true
      t.belongs_to :product, null: false, foreign_key: true
      t.datetime :deleted_at
      t.datetime :cancelled_at

      t.timestamps
    end
    add_index :orders, :serial, name: "index_orders_on_serial"
    add_index :orders, :service_date, name: "index_orders_on_service_date"
    add_index :orders, :cancelled_at, name: "index_orders_on_cancelled_at"
  end
end
