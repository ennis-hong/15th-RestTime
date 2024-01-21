# frozen_string_literal: true

class NotificationPolicy < ApplicationPolicy
  def destroy?
    user == record.user
  end
end
