# frozen_string_literal: true

class Shop < ApplicationRecord
  include Rails.application.routes.url_helpers

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

  scope :status, -> { where(status: 'open') }

  validates :title, presence: true
  validates :district, presence: true
  validates :city, presence: true
  validates :street, presence: true
  validates :contact, presence: true
  validates :tel, presence: true, length: { maximum: 15 },
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
    comments.average(:rating)&.round || 0
  end

  def create_service_times
    days = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
    ActiveRecord::Base.transaction do
      days.each do |day|
        st = ServiceTime.new(day_of_week: day, off_day: false, shop: self)
        st.save!
      end
    end
    message = "<a href='#{edit_service_times_path}'>#{I18n.t('message.set_business_hours')}</a>"
    send_notification(user, message)
  end

  # Geocoder
  geocoded_by :address
  after_validation :geocode, if: ->(obj) { obj.address_changed? }

  def address
    [city, district, street].compact.join(' ')
  end

  def address_changed?
    city_changed? || district_changed? || street_changed?
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[comments like_shops like_user orders products service_times
       user]
  end

  def send_notification(recipient, message)
    recipient.notifications.create(
      notifiable: self,
      message:
    )
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[city contact contactphone created_at deleted_at description district id id_value
       latitude longitude overlap status street tel title updated_at user_id]
  end

  def service_time_not_set?
    service_times.where('updated_at = created_at').count == service_times.count
  end

end
