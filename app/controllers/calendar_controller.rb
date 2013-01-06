class CalendarController < ApplicationController
  def show
    now = Time.zone.now
    @year = (params[:year] || now.year).to_i
    @month = (params[:month] || now.month).to_i
    @leases = current_user.leases

    @leases_by_date = @leases.inject({}) do |h, lease|
      lease.duration.each do |d|
        h[d] ||= []
        h[d] << lease
        h
      end
    end

    current_user.leases.all
  end
end
