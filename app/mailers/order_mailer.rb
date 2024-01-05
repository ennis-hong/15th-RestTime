# frozen_string_literal: true

class OrderMailer < ApplicationMailer
  # send mail to General
  def new_order_email_to_general(order)
    initialize_order(order)
    mail_message = t('mailer.appointment_successful', booked_name: @booked_name, shop_title: @shop_title,
                                                      formatted_date: @formatted_date)
    mail(to: @booked_email, subject: mail_message)
  end

  def change_order_email_to_general(order)
    initialize_order(order)
    mail_message = t('mailer.booking_time_adjusted', booked_name: @booked_name, service_date: @service_date)
    mail(to: @booked_email, subject: mail_message)
  end

  def redeem_order_email_to_general(order)
    initialize_order(order)
    mail_message = t('mailer.order_has_been_redeemed', booked_name: @booked_name, shop_title: @shop_title)
    mail(to: @booked_email, subject: mail_message)
  end

  def cancel_order_email_to_general(order)
    initialize_order(order)
    mail_message = t('mailer.you_has_been_cancelled', booked_name: @booked_name)
    mail(to: @booked_email, subject: mail_message)
  end

  # send mail to Admin
  def new_order_email_to_vendor(order)
    initialize_order(order)
    mail_message = t('mailer.have_new_order', service_date: @service_date)
    mail(to: @vendor_email, subject: mail_message)
  end

  def change_order_email_to_vendor(order)
    initialize_order(order)
    mail_message = t('mailer.change_booking_time', booked_name: @booked_name, service_date: @service_date)
    mail(to: @vendor_email, subject: mail_message)
  end

  def redeem_order_email_to_vendor(order)
    initialize_order(order)
    mail_message = t('mailer.order_redeemed', serial: @order.serial)
    mail(to: @vendor_email, subject: mail_message)
  end

  def cancel_order_email_to_vendor(order)
    initialize_order(order)
    mail_message = t('mailer.order_cancelled', serial: @order.serial)
    mail(to: @vendor_email, subject: mail_message)
  end

  private

  def initialize_order(order)
    @order = order
    @shop_title = @order.shop&.title
    @shop_address = "#{@order.shop.city}#{@order.shop.district}#{@order.shop.street}"
    @product_description = @order.product&.description
    @service_date = @order.service_date.strftime('%Y-%m-%d %H:%M')
    @formatted_date = @order.service_date.strftime('%Y年%m月%d日')
    @time_now = Time.now.strftime('%Y-%m-%d %H:%M')
    @booked_email = @order.booked_email
    @booked_name = @order.booked_name
    @vendor_email = @order.shop.user.email
    # @vendor_email = ENV['MAIL_USERNAME'] #測試用打開，不然會寄到假資料信箱
  end

end
