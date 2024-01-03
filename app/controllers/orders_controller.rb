# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!, except: %i[payment_result]
  before_action :order_params, only: :create
  before_action :find_order, only: %i[show cancel edit update]

  skip_before_action :verify_authenticity_token, only: :payment_result

  def my_bookings
    @orders = current_user.orders
  end

  def create
    @order = current_user.orders.new(order_params)
    @order.service_date = current_booking.service_date
    @order.price = booking_product.price
    @order.service_min = booking_product.service_min

    if @order.save
      # @order.confirm!在討論
      @paymentHtml = ecpay_pay(@order)
    else
      render 'bookings/checkout'
    end
  end

  def show
    @shop = @order.shop
    @url_string = confirm_redeem_vendor_order_url(@order, status: 'completed', host: request.host_with_port)
  end

  def edit
  end

  def update
    new_service_date = params[:order][:service_date]
    
    if @order.service_date != new_service_date
      if @order.update(service_date: new_service_date)
        redirect_to order_path(@order), notice: t('booking time adjusted', scope: %i[message])
      else
        render :edit
      end
    end
  end

  def cancel
    if @order.cancelled?
      redirect_to @order, alert: t('can not cancel', scope: %i[message])
    else
      if @order.cancel!
        @order.update(cancelled_at: Time.now)
        redirect_to @order, notice: t('you has been cancelled', scope: %i[message])
      else
        redirect_to @order, alert: t('cancellation error', scope: %i[message])
      end
    end
  end

  def payment_result
    result_params = payment_result_params

    @order = Order.find_by(serial: result_params[:MerchantTradeNo])
    @order.payment_date = result_params[:PaymentDate]
    @order.payment_type = result_params[:PaymentType]
    @order.payment_type_charge_fee = result_params[:PaymentTypeChargeFee]
    @order.return_code = result_params[:RtnCode]
    @order.return_msg = result_params[:RtnMsg]
    redirect_to order_path(@order), alert: t('Abnormal Payment Result', scope: %i[order message]) unless @order.save

    if result_params[:RtnCode] === '1'
      @order.pay!
      user = @order.user
      sign_in(user) if user
      redirect_to order_path(@order), notice: t('payment successful', scope: %i[order message])
    else
      redirect_to order_path(@order), notice: t('payment failed', scope: %i[order message])
    end
  end

  private

  def order_params
    params.require(:order)
          .permit(:booked_name, :booked_email, :staff)
          .merge(product: booking_product, shop: booking_shop)
  end

  def payment_result_params
    params.permit(:MerchantTradeNo, :PaymentDate,
                  :PaymentType, :PaymentTypeChargeFee,
                  :RtnCode, :RtnMsg, :TradeAmt)
  end

  def find_order
    @order = Order.find(params[:id])
  end

  def ecpay_pay(order)
    xml_file = File.open('./config/payment_conf.xml')
    config_xml = Nokogiri::XML(xml_file)
    ecpay_mode = config_xml.xpath('//Conf//OperatingMode').first
    ecpay_mode.content = ENV.fetch('ECPAY_MODE', nil)

    APIHelper.class_variable_set(:@@conf_xml, config_xml)
    ecpay_client = ECpayPayment::ECpayPaymentClient.new

    credit_params = generate_credit_param(order)
    ecpay_client.aio_check_out_credit_onetime(params: credit_params, invoice: {})
  end

  def generate_credit_param(order)
    {
      'MerchantTradeNo' => order.serial, # 請帶20碼uid, ex: f0a0d7e9fae1bb72bc93
      'MerchantTradeDate' => Time.current.strftime('%Y/%m/%d %H:%M:%S'), # ex: 2017/02/13 15:45:30
      'TotalAmount' => order.price.to_i,
      'TradeDesc' => "#{order.shop.title}:#{order.serial}",
      'ItemName' => order.product.title,
      'ReturnURL' => ENV.fetch('DOMAIN_NAME', nil),
      'PaymentType' => 'aio',
      'ChoosePayment' => 'Credit',
      'OrderResultURL' => "#{ENV.fetch('DOMAIN_NAME', nil)}/orders/payment_result"
    }
  end
end
