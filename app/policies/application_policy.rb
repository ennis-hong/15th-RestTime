# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  private

  def create_default_shop
    return false unless user.vendor? && user.shop.nil?

    # robocop會自動幫我改成反述法，如果 user.vendor & 沒有店家就執行以下

    shop = Shop.new(
      title: user.email,
      description: 'Default Description',
      district: 'Default District',
      city: 'Default City',
      street: 'Default Street',
      contact: 'Default Contact',
      tel: '000000000',
      contactphone: '000000000'
    )

    user.shop = shop
    shop.save
    true # 返回 true 表示店鋪已經被創建
  end
end
