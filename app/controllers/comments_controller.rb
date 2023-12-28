class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_shop

  def create
    @comment = @shop.comments.create(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to shop_path(@shop), notice: 'Comment has been created'
    else
      redirect_to shop_path(@shop), alert: 'Comment has not been created'
    end
  end

  def destroy
    @comment = @shop.comments.find(params[:id])
    @comment.destroy
    redirect_to shop_path(@shop)
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
