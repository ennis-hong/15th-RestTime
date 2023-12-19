class CreateShops < ActiveRecord::Migration[7.1]
  def change
    create_table :shops do |t|
      t.string :title
      t.string :tel
      t.text :description
      t.string :city
      t.string :district
      t.text :street
      t.datetime :deleted_at
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
