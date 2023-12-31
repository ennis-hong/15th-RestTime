# frozen_string_literal: true

class OrderPolicy < ApplicationPolicy
  attr_reader :user, :order

  def access_page?
    user == record.shop.user
  end
end
