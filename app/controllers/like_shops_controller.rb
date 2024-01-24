# frozen_string_literal: true

class LikeShopsController < ApplicationController
  def index
    @like_shops = LikeShop
    @shop = current_user
  end
end
