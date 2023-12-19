# frozen_string_literal: true
class ApplicationController < ActionController::Base

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    render file: Rails.public_path.join('404.html'),
          status: 404,
          layout: false
  end
end
