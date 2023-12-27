class ShopPolicy < ApplicationPolicy
  attr_reader :user, :shop

  def initialize(user, shop)
    @user = user
    @shop = shop
  end

  def index?
    user.shop.present? || create_default_shop || user.admin?
  end

  def new?
    user.admin?
  end

  def create?
    new?
  end

  def show?
    index?
  end

  def edit?
    index?
  end

  def update?
    index?
  end

  def destroy
    user.admin?
  end

  private

  def create_default_shop
    return false unless user.vendor? && user.shop.nil?

    # robocup會自動幫我改成反述法，如果 user.vendor & 沒有店家就執行以下

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
