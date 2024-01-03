# frozen_string_literal: true

class Shop < ApplicationRecord
  enum status: { closed: 'closed', open: 'open', busy: 'busy', shutdown: 'ShutDown' }
  paginates_per 8
  belongs_to :user

  has_one_attached :cover
  has_one_attached :cover do |f|
    f.variant :cover, resize_to_limit: [1000, 300]
    f.variant :thumb, resize_to_limit: [300, 200]
  end
  has_many :like_shops
  has_many :like_user, through: :like_shops, source: :user
  has_many :products
  has_many :service_times
  has_many :orders
  has_many :comments, -> { order(created_at: :desc) }

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

  def set_default_status
    self.status ||= 'closed'
  end

  def owned_by?(user)
    self.user == user
  end

  def average_rating
    total_ratings = comments.any? ? comments.average(:rating) : 0
    total_ratings.round
  end

  # 商店排序用，允許被搜尋到的東西
  def self.ransackable_attributes(_auth_object = nil)
    %w[city description district status street title updated_at open]
  end

  # 這行刪掉會壞掉，所以保留
  def self.ransackable_associations(_auth_object = nil)
    ['products']
  end
end
