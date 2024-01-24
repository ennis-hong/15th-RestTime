# frozen_string_literal: true

class LikeShopsController < ApplicationController
  before_action :authenticate_user!

  def show_user_like_shops
    # 获取当前用户的 like_shops
    @user_like_shops = current_user.like_shops
  end
end
