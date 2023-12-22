class CreateLikeShops < ActiveRecord::Migration[7.1]
  def change
    create_table :like_shops do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :shop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
