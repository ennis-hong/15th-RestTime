class ShopPolicy < ApplicationPolicy
  attr_reader :user, :shop

  def initialize(user, shop)
    @user = user
    @shop = shop
  end

  def new?
    user.vendor? && user.shop.nil?
    # 只有 User 的 role 為 'vendor' 且尚未擁有店鋪時才能夠創建店鋪
  end

  def create?
    user.vendor? && user.shop.nil?
    # 只有 User 的 role 為 'vendor' 且尚未擁有店鋪時才能夠創建店鋪
  end
end
