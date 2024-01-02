# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: %i[general vendor admin]

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true
  has_one :shop
  has_one :booking
  has_many :like_shops
  has_many :liked_shops, through: :like_shops, source: :shop
  has_many :orders
  has_many :comments

  def liked?(shop)
    liked_shop_ids.include?(shop.id)
  end

  def own?(product)
    shop&.products&.unscope(where: :onsale)&.include?(product)
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.find_by(email: data['email'])

    user ||= User.create(email: data['email'],
                         password: Devise.friendly_token[0, 20])

    user
  end
end
