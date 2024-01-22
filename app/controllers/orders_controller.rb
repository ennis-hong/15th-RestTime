# frozen_string_literal: true

class OrdersController < ApplicationController # rubocop:disable Metrics/ClassLength
  before_action :authenticate_user!, except: %i[payment_result]
  before_action :order_params, only: :create
  before_action :find_order, only: %i[show cancel edit update payment linepay]
  before_action :header_nonce, only: [:linepay_payment]

  skip_before_action :verify_authenticity_token, only: %i[payment_result confirm]

  def index
    @orders = current_user.orders.with_status(params[:status]).order(created_at: :desc)
  end

  def new
    @shop = current_user.shop
    @order = Order.new
  end

  def create
    @order = current_user.orders.new(order_params)
    @order.service_date = current_booking.service_date
    @order.price = booking_product.price
    @order.service_min = booking_product.service_min

    booking_service = BookingService.new(booking_product.shop, booking_product)
    return render :new, notice: t('order.booking_full') unless booking_service.available_booking?(@order.service_date)

    if @order.save
      case params[:order][:payment_type]
      when 'LINEPay'
        linepay_payment(@order)
      when 'CreditCard'
        add_mac_value(payment_params(@order))
      end
    else
      render :new
    end
  end

  def show
    authorize @order
    @shop = @order.shop
    @url_string = confirm_redeem_vendor_order_url(@order, status: 'completed', host: request.host_with_port)
  end

  def confirm_status
    authorize @order, :access_page?
    @status = params[:status]
    @staff = params[:staff]
  end

  def edit
    authorize @order
    @shop = @order.shop
    @url_string = confirm_redeem_vendor_order_url(@order, status: 'completed', host: request.host_with_port)
  end

  def update
    authorize @order
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
    authorize @order
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

  def payment
    authorize @order
    add_mac_value(payment_params(@order))
    respond_to(&:turbo_stream)
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

  # line
  def linepay_payment(order) # rubocop:disable Metrics/MethodLength
    @order = order

    # body
    order_id = "#{@order.serial}#{Time.now.strftime('%H%M%S')}"
    packages_id = "package#{SecureRandom.uuid}"
    amount = @order.price.to_i

    body = { amount:,
             currency: 'TWD',
             orderId: order_id,
             packages: [{ id: packages_id,
                          amount:,
                          products: [{
                            name: @order.product.title,
                            quantity: 1,
                            price: amount
                          }] }],
             redirectUrls: { confirmUrl: "#{ENV.fetch('DOMAIN_NAME', nil)}#{Rails.application.credentials.line.CONFIRM_URL}", # rubocop:disable Layout/LineLength
                             cancelUrl: ENV['DOMAIN_NAME'].to_s } }
    # header
    signature_uri = "/#{Rails.application.credentials.line.VERSION}/payments/request"
    create_header(signature_uri, body)
    conn = Faraday.new(
      url: "#{Rails.application.credentials.line.LINEPAY_SITE}/#{Rails.application.credentials.line.VERSION}/payments/request",
      headers: @header
    )

    response = conn.post do |req|
      req.body = body.to_json
    end
    parsed_response = JSON.parse(response.body)
    if parsed_response['returnCode'] == '0000'
      redirect_to parsed_response['info']['paymentUrl']['web'], allow_other_host: true
    else
      redirect_to order_path(@order), notice: t(:payment_failed, scope: %i[message])
      puts parsed_response
    end
  end

  # line再次付款
  def linepay
    linepay_payment(@order)
  end

  def confirm # rubocop:disable Metrics/MethodLength
    transaction_id = params[:transactionId]
    order_serial = params[:orderId].to_s.gsub(/\d{6}\z/, '')
    @order = Order.find_by(serial: order_serial)
    amount = @order.price.to_i

    body = {
      amount:,
      currency: 'TWD'
    }
    signature_uri = "/#{Rails.application.credentials.line.VERSION}/payments/#{transaction_id}/confirm"
    create_header(signature_uri, body)

    conn = Faraday.new(
      url: "#{Rails.application.credentials.line.LINEPAY_SITE}/v3/payments/#{transaction_id}/confirm",
      headers: @header
    )

    response = conn.post do |req|
      req.body = body.to_json
    end
    parsed_response = JSON.parse(response.body)
    puts "Confirm Response: #{response.body}"

    if parsed_response['returnCode'] == '0000'
      trade_no = parsed_response['info']['transactionId']
      @order.pay!(trade_no:)
      user = @order.user
      sign_in(user) if user
      redirect_to order_path(@order), notice: t(:payment_successful, scope: %i[message])
    else
      redirect_to order_path(@order), notice: t(:payment_failed, scope: %i[message])
    end
  end

  def create_header(signature_uri, body)
    nonce = SecureRandom.uuid
    secret = Rails.application.credentials.line.SECRET_KEY
    message = "#{secret}#{signature_uri}#{body.to_json}#{nonce}"
    hash = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secret, message)
    @signature = Base64.strict_encode64(hash)
    @header = { 'Content-Type': 'application/json',
                'X-LINE-ChannelId': "#{Rails.application.credentials.line[:CHANNEL_ID]}", # rubocop:disable Style/RedundantInterpolation
                'X-LINE-Authorization-Nonce': nonce,
                'X-LINE-Authorization': @signature }
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
          .permit(:booked_name, :booked_email, :staff, :payment_type).merge(product: booking_product, shop: booking_shop)
  end

  def payment_result_params
    params.permit(:MerchantTradeNo, :TradeNo, :PaymentDate, :PaymentType, :PaymentTypeChargeFee, :RtnCode, :RtnMsg,
                  :TradeAmt)
  end

  def find_order
    @order = Order.find(params[:id])
  end
end
