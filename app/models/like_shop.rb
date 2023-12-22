# frozen_string_literal: true

class LikeShop < ApplicationRecord
  belongs_to :user
  belongs_to :shop
end
