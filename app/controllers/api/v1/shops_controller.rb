# frozen_string_literal: true

module Api
  module V1
    class ShopsController < ApplicationController
      before_action :find_shop, only: [:like]
      before_action :authenticate_user!

      def like
        if current_user.liked?(@shop)
          current_user.liked_shops.destroy(@shop)
          render json: { id: params[:id], status: 'unliked' }
        else
          current_user.liked_shops << @shop
          render json: { id: params[:id], status: 'liked' }
        end
      end

      private

      def find_shop
        @shop = Shop.find(params[:id])
      end
    end
  end
end
