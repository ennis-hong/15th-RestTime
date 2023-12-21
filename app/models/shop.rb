# frozen_string_literal: true

class Shop < ApplicationRecord
  belongs_to :user
  has_many :products
  validates :title, presence: true
  validates :description, presence: true
  validates :district, presence: true
  validates :street, presence: true
  validates :contact, presence: true
  validates :tel, presence: true, length: { maximum: 50 },
                  format: { with: /\A[\d\+\-\(\)]+\z/, message: '格式不正確' }
  validates :contactphone, presence: true, length: { maximum:50 },
                  format: { with: /\A[\d\+\-\(\)]+\z/, message: '格式不正確' }
end
