# frozen_string_literal: true

class Product < ApplicationRecord
  validates :title, presence: true
  validates :service_min, presence: true
  validates :price, numericality: { greater_than: 0 }

  belongs_to :shop

  acts_as_list

  paginates_per 8
  scope :onsale, -> { where(onsale: true) }

  # 商品圖片
  has_one_attached :cover

  has_one_attached :cover do |f|
    f.variant :cover, resize_to_limit: [800, 800]
    f.variant :thumb, resize_to_limit: [400, 400]
    f.variant :order_thumb, resize_to_limit: [120, 120]
  end

  # 軟刪除
  acts_as_paranoid

  # ransack
  def self.ransackable_attributes(_auth_object = nil)
    %w[description price title]
  end
end
