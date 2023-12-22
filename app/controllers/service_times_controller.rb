# frozen_string_literal: true

class ServiceTimesController < ApplicationController
  before_action :authenticate_user!

  def edit
    ServiceTime.default_data(current_user_shop) if current_user_shop.service_times.empty?
    @configs = current_user_shop.service_times
  end

  def update
    service_time_params = service_params.index_by { |param| param[:id].to_i }
    @configs = ServiceTime.where(shop_id: current_user_shop.id, id: service_time_params.keys)

    failed_updates = 0
    ServiceTime.transaction do
      @configs.each do |config|
        failed_updates += 1 unless config.update(service_time_params[config.id])
      end
      raise ActiveRecord::Rollback if failed_updates.positive?
    end

    if failed_updates.positive?
      render :edit
    else
      redirect_to shop_path(current_user_shop),
                notice: t(:success, scope: %i[service_times message])
    end

  end

  def service_params
    params.require(:service_times).values.map do |param|
      param.permit(:id, :day_of_week, :open_time, :close_time,
                   :lunch_start, :lunch_end, :off_day)
    end
  end
end
