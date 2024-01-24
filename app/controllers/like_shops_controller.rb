# frozen_string_literal: true

class LikeShopsController < ApplicationController
  before_action :authenticate_user!

  def index
    @shops = current_user.liked_shops.page(params[:page])
  end
end
