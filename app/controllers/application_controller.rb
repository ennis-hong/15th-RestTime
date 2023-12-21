# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_ransack_obj
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    render file: Rails.public_path.join('404.html'),
           status: 404,
           layout: false
  end

  def set_ransack_obj
    @q = Product.ransack(params[:q])
  end

  def default_url_options
    { lang: I18n.locale }
  end

  def switch_locale(&)
    lang = params[:lang] || I18n.default_locale
    I18n.with_locale(lang, &)
  end
end
