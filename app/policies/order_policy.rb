# frozen_string_literal: true

class OrderPolicy < ApplicationPolicy
  def access_page?
    user == record.shop.user
  end

  def show?
    user.orders.include?(record)
  end

  def edit?
    show?
  end

  def update?
    show?
  end

  def cancel?
    show?
  end

  def payment?
    user.orders.include?(record) && record.may_pay?
  end
end
