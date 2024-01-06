# frozen_string_literal: true

module Avo
  module Resources
    class Shop < Avo::BaseResource
      self.includes = []

      def fields
        field :id, as: :id
        field :title, as: :text
        field :tel, as: :text
        field :description, as: :textarea
        field :deleted_at, as: :date_time
        field :city, as: :text
        field :district, as: :text
        field :street, as: :textarea
        field :user_id, as: :number
        field :contact, as: :text
        field :contactphone, as: :text
        field :status, as: :select, enum: ::Shop.statuses
        field :cover, as: :file
        field :user, as: :belongs_to
        field :like_shops, as: :has_many
        field :like_user, as: :has_many, through: :like_shops
        field :products, as: :has_many
        field :service_times, as: :has_many
      end
    end
  end
end
