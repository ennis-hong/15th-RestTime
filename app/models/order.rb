# frozen_string_literal: true

class Order < ApplicationRecord
  # include AASM
  acts_as_paranoid

  validates :booked_email, presence: true

  belongs_to :user
  belongs_to :shop
  belongs_to :product

  before_create :generate_serial

  # aasm column: 'status', no_direct_assignment: true do
  #   state :pending, initial: true
  #   state :confirmed, :paid, :refunded, :cancelled, :completed

  #   event :confirm do
  #     transitions from: :pending, to: :confirmed
  #   end

  #   event :pay do
  #     transitions from: :pending, to: :paid
  #   end

  #   event :complete do
  #     # transitions from: %i[pending paid], to: :completed
  #   end

  #   event :cancel do
  #     transitions from: %i[pending paid], to: :cancelled
  #   end
  # end

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
