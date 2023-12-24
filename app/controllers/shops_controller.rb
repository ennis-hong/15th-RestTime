class ShopsController < ApplicationController
  before_action :find_shop, only: %i[show]
  before_action :check_shop_presence, only: %i[new create]
  before_action :check_ownership, only: %i[edit update]
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_owned_shop, only: %i[edit update destroy]

  # 搜尋修改後
  def index
    @shop = current_user&.shop
    @q = Shop.ransack(params[:q])
    @shops = @q.result(distinct: true).order(order_by).page(params[:page]).per(8)
  end

  def new
    if current_user.shop.present?
      redirect_to new_product_path, alert: '你已經擁有一家店，趕緊刊登服務商品吧！'
    else
      @shop = Shop.new
    end
  end

  def create
    @shop = current_user.build_shop(shop_params)
    if @shop.save
      redirect_to shop_path(@shop), notice: '店家建立成功'
    else
      render :new
    end
  end

  def edit; end

  def show
  end

  def update
    if @shop.update(shop_params)
      redirect_to shop_path, notice: '店家資訊更新成功'
    else
      render :edit
    end
  end

  def destroy
  end

  private

  def shop_params
    params.require(:shop).permit(:title, :tel, :description, :city, :district, :street, :contact, :contactphone,
                                 :cover, :status)
  end

  def find_shop
    @shop = Shop.find(params[:id])
  end

  def find_owned_shop
    @shop = current_user.shop
  end

  # 搜尋新增
  def order_by
    order_options = {
      'city desc' => 'city desc',
      'updated_at desc' => 'updated_at desc'
    }

    selected_option = params.dig(:q, :s)
    order_options[selected_option] || 'city desc'
  end

  def check_shop_presence
    current_user.shop.nil?
  end

  def check_ownership
    if current_user == @shop
      redirect_to root_path, alert: "你走錯地方了"
    end
  end
  
end
