class CreateServiceTimes < ActiveRecord::Migration[7.1]
  def change
    create_table :service_times do |t|
      t.string :day_of_week, null: false
      t.time :open_time
      t.time :close_time
      t.time :lunch_start
      t.time :lunch_end
      t.boolean :off_day, default: false
      t.belongs_to :shop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
