# frozen_string_literal: true

module Avo
  module Resources
    class User < Avo::BaseResource
      self.includes = []
      # self.search = {
      #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
      # }

      def fields
        field :id, as: :id
        field :email, as: :text
        field :password, as: :password
        field :role, as: :select, enum: ::User.roles
        field :shop, as: :has_one
        field :like_shops, as: :has_many
        field :liked_shops, as: :has_many, through: :like_shops
      end
    end
  end
end
