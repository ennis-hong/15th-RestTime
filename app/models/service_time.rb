# frozen_string_literal: true

class ServiceTime < ApplicationRecord
  belongs_to :shop

  # 預設寫入週一至週日共七筆設定資料
  def self.default_data(shop)
    days = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
    days.each do |day|
      shop.service_times << ServiceTime.build(day_of_week: day, shop:)
    end
  end
end
