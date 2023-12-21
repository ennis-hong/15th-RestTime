# frozen_string_literal: true

class ServiceTimesController < ApplicationController
  before_action :authenticate_user!

  def edit
    ServiceTime.default_data(current_shop) if current_shop.service_times.empty?
    @configs = current_shop.service_times
  end

  def update
    current_shop.service_times.each do |config|
      config.update(get_configs_param(config))
    end
    redirect_to shop_path(current_shop), notice: t(:success, scope: %i[service_times message])
  end

  def get_configs_param(config)
    service_params = params.require(:service_times)
    configs_param = service_params.values.find { |config_param| config_param[:id].to_i == config.id }
    configs_param.permit(:day_of_week, :open_time, :close_time, :lunch_start, :lunch_end, :off_day)
  end
end
