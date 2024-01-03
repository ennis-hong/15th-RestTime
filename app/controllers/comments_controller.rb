class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_shop

  def new
    @comment = Comment.new
  end

  def create
    @comment = @shop.comments.create(comment_params)

    if @comment.save
      redirect_to shop_path(@shop), notice: t('comment.comment_created')
    else
      redirect_to shop_path(@shop), alert: t('comment.comment_not_created')
    end
  end

  private

  def find_shop
    @shop = Shop.find(params[:shop_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :rating).merge(user: current_user)
  end
end
