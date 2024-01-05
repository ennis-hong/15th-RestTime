# frozen_string_literal: true

class ServiceTimesController < ApplicationController
  before_action :authenticate_user!

  def edit
    authorize :shop, :edit?
    @service_times = current_user_shop.service_times
  end

  def update
    authorize :shop, :update?
    service_time_params = service_params.index_by { |param| param[:day_of_week] }
    @service_times = current_user_shop.service_times

    ServiceTime.transaction do
      update_result = @service_times.map do |service_time|
        update_params = service_time_params.fetch(service_time.day_of_week)
        service_time.update(update_params) if update_params.present?
      end

      raise ActiveRecord::Rollback unless update_result.all?

      redirect_to vendor_index_path,
                  notice: t(:success, scope: %i[service_times message])
    rescue ActiveRecord::Rollback
      render :edit
    end
  end

  def service_params
    params.require(:service_times).values.map do |param|
      param.permit(:day_of_week, :open_time, :close_time,
                   :lunch_start, :lunch_end, :off_day)
    end
  end
end
