class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  after_create :notify

  def notify

    broadcast_render_to(
      user,
      partial: "notifications/new",
      local: { target: "notification", notification: self }
    )
  end
end
