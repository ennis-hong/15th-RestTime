# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_rich_text :body
  validates :rating, numericality: { in: 0..5 }, presence: true
end
