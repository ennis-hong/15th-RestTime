# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: %i[general vendor]
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true
  has_one :shop
  has_many :like_shops
  has_many :liked_shops, through: :like_shops, source: :shop

  def liked?(shop)
    liked_shop_ids.include?(shop.id)
  end
end
