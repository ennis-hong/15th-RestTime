# frozen_string_literal: true

class Product < ApplicationRecord
  validates :title, presence: true
  validates :service_min, presence: true
  validates :price, numericality: { greater_than: 0 }

  acts_as_list

  # 商品圖片
  has_one_attached :cover

  has_one_attached :cover do |f|
    f.variant :cover, resize_to_limit: [800, 800]
    f.variant :thumb, resize_to_limit: [400, 400]
  end

  # 軟刪除
  acts_as_paranoid

  # ransack
  def self.ransackable_attributes(_auth_object = nil)
    %w[description price title]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
