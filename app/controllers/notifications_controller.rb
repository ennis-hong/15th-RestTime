# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :find_notification

  def destroy
    authorize @notification
    @notification.destroy
    render json: { message: 'success' }
  end

  private

  def find_notification
    @notification = Notification.find(params[:id])
  end
end
