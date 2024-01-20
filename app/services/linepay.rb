# frozen_string_literal: true
class LinePay # rubocop:disable Layout/EmptyLineAfterMagicComment
  before_action :header_nonce, only: [:create]
  before_action :body, only: [:create]
  before_action :header, only: [:create]

  def create
    @nonce = SecureRandom.uuid
    begin
      conn = Faraday.new(
        url: "#{Rails.application.credentials.line.LINEPAY_SITE}/#{Rails.application.credentials.line.VERSION}/payments/request",
        headers: @header
      )

      response = conn.post do |req|
        req.body = @body.to_json
      end

      puts "Line Pay Response: #{response.body}" # 将返回的主体部分打印到控制台

      parsed_response = JSON.parse(response.body)
      if parsed_response['returnCode'] == '0000'
        redirect_to parsed_response['info']['paymentUrl']['web'], allow_other_host: true
      else
        puts parsed_response
      end
    rescue StandardError => e
      puts e.message
    end
  end

  def confirm
    response = Faraday.post("#{Rails.application.credentials.line.LINEPAY_SITE}/#{Rails.application.credentials.line.VERSION}/payments/#{params[:transactionId]}/confirm") do |req|
      request_header(req)
      req.body = {
        amount:,
        currency: 'TWD'
      }.to_json
    end

    result = JSON.parse(response.body)

    if result['returnCode'] == '0000'
      redirect_to products_path, notice: '您的訂單已成功付款'
    else
      puts "API error：#{result['returnCode']} - #{result['returnMessage']}"

      redirect_to root_path, notice: '支付失败，请联系客服处理'
    end
  rescue Faraday::Error => e
    puts "error：#{e.message}"
    redirect_to root_path, notice: '支付请求失败，请稍后重试'
  rescue StandardError => e
    puts "unknow error：#{e.message}"
    redirect_to root_path, notice: '支付请求失败，请稍后重试'
  end

  def cancel
    @order = current_user.orders.find(params[:id])

    if @order.已付款?
      response = Faraday.post("#{Rails.application.credentials.line.LINEPAY_SITE}/#{Rails.application.credentials.line.VERSION}/payments/#{@order[:transaction_id]}/refund") do |req|
        request_header(req)
      end
      result = JSON.parse(response.body)

      if result['returnCode'] == '0000'
        @order.refund!
        redirect_to orders_path, notice: "訂單 #{@order.num}已完成退款"
        @notice = current_user.notices.create(notices: flash[:notice])
      else
        redirect_to orders_path, notice: '退款失敗'
      end
    else
      redirect_to root_path
    end
  end

  def body
    order_id = "order#{SecureRandom.uuid}"
    packages_id = "package#{SecureRandom.uuid}"
    amount = params[:quantity].to_i * params[:price].to_i

    @body = { amount:,
              currency: 'TWD',
              orderId: order_id,
              packages: [{ id: packages_id,
                           amount:,
                           products: [{
                             name: params[:name],
                             quantity: 1,
                             price: params[:price].to_i
                           }] }],
              redirectUrls: { confirmUrl: "#{Rails.application.credentials.line.DOMAIN_NAME}/products",
                              cancelUrl: "#{Rails.application.credentials.line.DOMAIN_NAME}" } }
  end

  private

  def header_nonce
    @nonce = SecureRandom.uuid
  end

  def header
    get_signature
    @header = { 'Content-Type': 'application/json',
                'X-LINE-ChannelId': Rails.application.credentials.line.CHANNEL_ID.to_s,
                'X-LINE-Authorization-Nonce': @nonce,
                'X-LINE-Authorization': @signature }
  end

  def get_signature
    secrect = Rails.application.credentials.line.SECRET_KEY
    signature_uri = "/#{Rails.application.credentials.line.VERSION}/payments/request"
    message = "#{secrect}#{signature_uri}#{@body.to_json}#{@nonce}"
    hash = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secrect, message)
    @signature = Base64.strict_encode64(hash)
  end
end
