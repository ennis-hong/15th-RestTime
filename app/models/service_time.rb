# frozen_string_literal: true

class ServiceTime < ApplicationRecord
  belongs_to :shop
  before_validation :validate_open_and_close_times, on: :update

  # 預設寫入週一至週日共七筆設定資料
  def self.default_data(shop)
    days = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
    days.each do |day|
      shop.service_times << ServiceTime.build(day_of_week: day, shop:)
    end
  end

  private

  def validate_open_and_close_times
    return if off_day

    if open_time.present? && close_time.blank?
      errors.add(:close_time, "can't be blank if open time is set")
      return
    end

    return unless close_time.present? && open_time.blank?

    errors.add(:close_time, "can't be blank if close time is set")
  end
end
