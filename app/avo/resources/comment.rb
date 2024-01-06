# frozen_string_literal: true

module Avo
  module Resources
    class Comment < Avo::BaseResource
      self.includes = []

      def fields
        field :id, as: :id
        field :user, as: :text
        field :shop, as: :text
      end
    end
  end
end
