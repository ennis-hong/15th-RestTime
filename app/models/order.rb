# frozen_string_literal: true

class Order < ApplicationRecord
  include AASM
  acts_as_paranoid

  attr_accessor :linepay_transaction_id

  validates :booked_email, presence: true

  belongs_to :user
  belongs_to :shop
  belongs_to :product

  before_create :generate_serial

  scope :valid, -> { where.not(status: %i[completed cancelled]) }
  scope :with_status, ->(status) { where(status:) if status.present? }

  aasm column: 'status', no_direct_assignment: true do
    state :pending, initial: true
    state :paid, :refunded, :cancelled, :completed

    event :pay do
      transitions from: :pending, to: :paid
    end

    event :complete do
      transitions from: %i[pending paid], to: :completed
    end

    event :cancel do
      transitions from: %i[pending paid], to: :cancelled
    end
  end

  def shop
    product&.shop
  end

  # simple_calendar用
  def start_time
    service_date
  end

  # simple_calendar用
  def end_time
    service_date + product.service_min.minutes
  end

  private

  def generate_serial
    self.serial = serial_generator
  end

  def serial_generator(digits = 6)
    today = Time.current.strftime('%Y%m%d')
    code = SecureRandom.alphanumeric.upcase[0..digits - 1]

    "RT#{today}#{code}"
  end
end
