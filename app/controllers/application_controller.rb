class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordNotSaved, with: :not_saved
  helper_method :current_user_shop
  layout :set_layout # 設置判斷登入的使用者layout頁面

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

  def current_user_shop
    current_user.shop
  end

  def set_layout
    if current_user&.vendor?
      'vendor'
    else
      'application'
    end
  end
end
