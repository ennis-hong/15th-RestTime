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
    user.shop.present? || create_default_shop || user.admin?
  end

  def new?
    my?
  end

  def create?
    my?
  end

  def edit?
    user&.own?(product) || user&.admin?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def search?
    true
  end
end
