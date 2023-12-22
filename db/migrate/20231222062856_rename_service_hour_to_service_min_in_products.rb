class RenameServiceHourToServiceMinInProducts < ActiveRecord::Migration[7.1]
  def change
    rename_column :products, :service_hour, :service_min
  end
end
