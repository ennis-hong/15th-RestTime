# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_rich_text :body
  validates :rating, numericality: { in: 0..5 }, presence: true
  validates :user_id, uniqueness: { scope: :shop_id, message: 'You can only leave one comment per shop.' }
end
