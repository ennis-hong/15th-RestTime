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
  after_create :create_service_times

  validates :title, presence: true
  validates :district, presence: true
  validates :city, presence: true
  validates :street, presence: true
  validates :contact, presence: true
  validates :tel, presence: true, length: { maximum: 10 },
                  format: { with: /\A[\d\+\-\(\)]+\z/, message: '格式不正確' }

  validates :contactphone, presence: true, length: { maximum: 10 },
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

  def create_service_times
    days = %w[monday tuesday wednesday thursday friday saturday sunday]
    days.each do |day|
      ServiceTime.create(day_of_week: day, off_day: true, shop: self)
    end
  end

  # 商店排序用，允許被搜尋到的東西
  def self.ransackable_attributes(_auth_object = nil)
    %w[city description district status street title updated_at open]
  end
end
