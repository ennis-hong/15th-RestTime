class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  after_create :notify_order

  scope :top_five, -> { where(read_at: nil).limit(5) }
  default_scope { order(id: :desc) }

  def notify_order
    broadcast_render_to(
      user,
      partial: "notifications/new",
      local: { target: "notification", notification: self }
    )
  end
end
