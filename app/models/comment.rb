class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :shop
  has_rich_text :body
end
