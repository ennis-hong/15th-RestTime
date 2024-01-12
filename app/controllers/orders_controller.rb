# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!, except: %i[payment_result]
  before_action :order_params, only: :create
  before_action :find_order, only: %i[show cancel edit update]

  skip_before_action :verify_authenticity_token, only: :payment_result

  def index
    @orders = current_user.orders
  end

  def new
    @order = Order.new
  end

  def create
    @order = current_user.orders.new(order_params)
    @order.service_date = current_booking.service_date
    @order.price = booking_product.price
    @order.service_min = booking_product.service_min

    if @order.save
      add_mac_value(payment_params(@order))
    else
      render :new
    end
  end

  def show
    @shop = @order.shop
    @url_string = confirm_redeem_vendor_order_url(@order, status: 'completed', host: request.host_with_port)
  end

  def confirm_status
    authorize @order, :access_page?
    @status = params[:status]
    @staff = params[:staff]
  end

  def edit
    @shop = @order.shop
    @url_string = confirm_redeem_vendor_order_url(@order, status: 'completed', host: request.host_with_port)
  end

  def update
    new_service_date = params[:order][:service_date]

    return unless @order.service_date != new_service_date

    if @order.update(service_date: new_service_date)
      redirect_to order_path(@order), notice: t('booking_time_adjusted', scope: %i[message])
      OrderMailer.change_order_email_to_general(@order).deliver_later
      OrderMailer.change_order_email_to_vendor(@order).deliver_later
    else
      render :edit
    end
  end

  def cancel
    if @order.cancelled?
      redirect_to @order, alert: t('can_not_cancel', scope: %i[message])
    elsif @order.cancel!
      @order.update(cancelled_at: Time.now)
      redirect_to @order, notice: t('you_has_been_cancelled', scope: %i[message])
      OrderMailer.cancel_order_email_to_general(@order).deliver_later
      OrderMailer.cancel_order_email_to_vendor(@order).deliver_later
    else
      redirect_to @order, alert: t('cancellation_error', scope: %i[message])
    end
  end

  def payment_result
    result_params = payment_result_params
    @order = Order.find_by(serial: result_params[:MerchantTradeNo].slice(0, 16))
    payment_hash = {
      trade_no: result_params[:TradeNo],
      payment_date: result_params[:PaymentDate],
      payment_type: result_params[:PaymentType],
      payment_type_charge_fee: result_params[:PaymentTypeChargeFee],
      return_code: result_params[:RtnCode],
      return_msg: result_params[:RtnMsg]
    }
    unless @order.update(payment_hash)
      redirect_to order_path(@order),
                  alert: t(:abnormal_payment_result, scope: %i[message])
    end

    if result_params[:RtnCode] == '1'
      @order.pay!
      user = @order.user
      sign_in(user) if user
      redirect_to order_path(@order), notice: t(:payment_successful, scope: %i[message])
    else
      redirect_to order_path(@order), notice: t(:payment_failed, scope: %i[message])
    end
  end

  private

  def payment_params(order)
    @hash = {
      MerchantID: Rails.application.credentials.dig(:ecpay, :merchant_id),
      MerchantTradeNo: order.serial.concat(Time.current.strftime('%H%M')),
      MerchantTradeDate: Time.current.strftime('%Y/%m/%d %H:%M:%S'),
      PaymentType: 'aio',
      TotalAmount: order.price.to_i,
      TradeDesc: "#{order.shop.title}:#{order.serial}",
      ItemName: order.product.title,
      ReturnURL: ENV.fetch('DOMAIN_NAME', nil),
      OrderResultURL: "#{ENV.fetch('DOMAIN_NAME', nil)}/orders/payment_result",
      ChoosePayment: 'Credit',
      EncryptType: '1'
    }
  end

  def add_mac_value(params)
    params[:CheckMacValue] = compute_check_mac_value(params)
  end

  # 計算檢查碼
  def compute_check_mac_value(params)
    query_string = to_query_string(params)
    query_string.prepend("HashKey=#{Rails.application.credentials.dig(:ecpay, :hash_key)}&")
    query_string.concat("&HashIV=#{Rails.application.credentials.dig(:ecpay, :hash_iv)}")
    raw = urlencode_dot_net(query_string)
    @sha_code = Digest::SHA256.hexdigest(raw).upcase
  end

  def urlencode_dot_net(raw_data)
    encoded_data = CGI.escape(raw_data).downcase
    encoded_data.gsub!('%2d', '-')
    encoded_data.gsub!('%5f', '_')
    encoded_data.gsub!('%2e', '.')
    encoded_data.gsub!('%21', '!')
    encoded_data.gsub!('%2a', '*')
    encoded_data.gsub!('%28', '(')
    encoded_data.gsub!('%29', ')')
    encoded_data.gsub!('%20', '+')
    encoded_data
  end

  def to_query_string(params)
    params = params.sort_by do |key, _val|
      key.downcase
    end

    params = params.map do |key, val|
      "#{key}=#{val}"
    end
    params.join('&')
  end

  def order_params
    params.require(:order)
          .permit(:booked_name, :booked_email, :staff).merge(product: booking_product, shop: booking_shop)
  end

  def payment_result_params
    params.permit(:MerchantTradeNo, :TradeNo, :PaymentDate, :PaymentType, :PaymentTypeChargeFee, :RtnCode, :RtnMsg,
                  :TradeAmt)
  end

  def find_order
    @order = Order.find(params[:id])
  end
end
