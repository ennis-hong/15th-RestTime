class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :notifiable, polymorphic: true, null: false
      t.string :title
      t.text :message
      t.datetime :read_at

      t.timestamps
    end
  end
end
