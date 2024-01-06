# frozen_string_literal: true

module Avo
  module Resources
    class Product < Avo::BaseResource
      self.includes = []

      def fields
        field :id, as: :id
        field :title, as: :text
        field :description, as: :textarea
        field :price, as: :number
        field :onsale, as: :boolean
        field :deleted_at, as: :date_time
        field :position, as: :number
        field :publish_date, as: :date_time
        field :service_min, as: :number
        field :shop_id, as: :number
        field :cover, as: :file
        field :shop, as: :belongs_to
      end
    end
  end
end
