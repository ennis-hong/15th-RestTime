# frozen_string_literal: true

class Shop < ApplicationRecord
  enum status: { closed: 'closed', open: 'open', busy: 'busy', ShutDown: 'ShutDown' }

  belongs_to :user

  has_one_attached :cover
  has_one_attached :cover do |f|
    f.variant :cover, resize_to_limit: [1000, 300]
    f.variant :thumb, resize_to_limit: [300, 200]
  end
  has_many :like_shops
  has_many :like_user, through: :like_shops, source: :user
  has_many :products

  before_create :set_default_status

  validates :title, presence: true
  validates :description, presence: true
  validates :district, presence: true
  validates :city, presence: true
  validates :street, presence: true
  validates :contact, presence: true
  validates :tel, presence: true, length: { maximum: 50 },
                  format: { with: /\A[\d\+\-\(\)]+\z/, message: '格式不正確' }
  validates :contactphone, presence: true, length: { maximum: 50 },
                           format: { with: /\A[\d\+\-\(\)]+\z/, message: '格式不正確' }

  private

  def set_default_status
    self.status ||= 'open'
  end
end
