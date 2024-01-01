class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_rich_text :body
  validates :rating, numericality: { in: 0..5 }
  validates :body, presence: true
  validates :user_id, uniqueness: { scope: :shop_id, message: 'You can only leave one comment per shop.' }

  validate :rating_and_body_presence

  private

  def rating_and_body_presence
    return unless rating.blank? || body.blank?

    errors.add(:base, 'Both rating and body must be present.')
  end
end
