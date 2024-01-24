# frozen_string_literal: trueclass LikeShop < ApplicationRecord
  belongs_to :user
  belongs_to :shop
end
