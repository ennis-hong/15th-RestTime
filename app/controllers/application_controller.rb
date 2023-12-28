# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  around_action :switch_locale
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordNotSaved, with: :not_saved
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  layout :set_layout # 設置判斷登入的使用者layout頁面
  helper_method :show_vendor_link?
  helper_method :current_user_shop, :current_booking, :booking_shop, :booking_product

  def show_vendor_link
    authorize :application, :show_vendor_stuff?
  end

  protect_from_forgery with: :exception

  def not_found
    render file: Rails.public_path.join('404.html'),
           status: 404,
           layout: false
  end

  def not_saved
    render file: Rails.public_path.join('422.html'),
           status: 422,
           layout: false
  end

  def default_url_options
    { lang: I18n.locale }
  end

  def switch_locale(&)
    lang = params[:lang] || I18n.default_locale
    I18n.with_locale(lang, &)
  end

  def authenticate_user!
    return if user_signed_in?

    respond_to do |format|
      format.html do
        redirect_to sign_in_users_path, alert: '請先登入帳號'
      end

      format.json do
        render json: {
          message: '請先登入帳號',
          url: sign_in_users_path
        }, status: 401
      end
    end
  end

  def current_user_shop
    current_user.shop
    Shop.where(user_id: current_user.id)
  end

  def set_layout
    if current_user&.vendor?
      'vendor'
    else
      'application'
    end
  end

  def not_authorized
    redirect_to root_path, alert: '權限不足'
  end

  def current_booking
    return unless user_signed_in?

    @__booking__ ||= current_user.booking
  end

  def booking_shop
    current_booking.product.shop
  end

  def booking_product
    current_booking.product
  end
end
