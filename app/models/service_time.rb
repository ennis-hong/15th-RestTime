# frozen_string_literal: true

class ServiceTime < ApplicationRecord
  belongs_to :shop
  before_validation :validate_open_and_close_times, on: :update

  default_scope { order(id: :desc) }

  private

  def validate_open_and_close_times
    return if off_day

    if open_time.present? && close_time.blank?
      errors.add(:base, :close_time_blank)
      return
    end

    return unless close_time.present? && open_time.blank?

    errors.add(:base, :open_time_blank)
  end
end
