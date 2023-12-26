class ProductPolicy < ApplicationPolicy
  attr_reader :user, :product

  def initialize(user, product)
    @user = user
    @product = product
  end

  def index?
    true
  end

  def show?
    true
  end

  def my?
    (user.vendor? && user.shop.present?) || user.admin?
  end

  def new?
    vendor_with_shop? || user.admin?
  end

  def create?
    vendor_with_shop? || user.admin?
  end

  def edit?
    vendor_with_shop? || (user.admin? && user_can_manage_product_in_shop?)
  end

  def update?
    vendor_with_shop? || (user.present? && user.admin? && user_can_manage_product_in_shop?)
  end

  def destroy?
    vendor_with_shop? || user.admin?
  end

  def search?
    true
  end

  private

  def vendor_with_shop?
    user.present? && user.vendor? && user.shop.present?
  end

  def user_can_manage_product_in_shop?
    user.admin? && product.shop_id
  end
end
