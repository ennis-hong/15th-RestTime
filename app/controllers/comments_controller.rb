class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_shop

  def new
    @comment = Comment.new
  end

  def create
    @comment = @shop.comments.create(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to shop_path(@shop), notice: t('comment.comment has been created')
    else
      redirect_to shop_path(@shop), notice: t('comment.comment has not been created')
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @toast = if @comment.update(rating: params[:comment][:rating])
               :success
             else
               :warning

             end
    render 'show'
  end

  private

  def find_shop
    @shop = Shop.find(params[:shop_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :rating)
  end
end
