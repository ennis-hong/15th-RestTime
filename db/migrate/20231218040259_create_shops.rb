class CreateShops < ActiveRecord::Migration[7.1]
  def change
    create_table :shops do |t|
      t.string :title
      t.string :tel
      t.text :description
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
