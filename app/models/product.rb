# frozen_string_literal: true

class Product < ApplicationRecord
  validates :title, presence: true
  validates :price, numericality: { greater_than: 0 }

  def destroy
    update(deleted_at: Time.current)
  end
end
