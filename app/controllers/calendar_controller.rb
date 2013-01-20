class CalendarController < ApplicationController
  def show
    now = Time.zone.now
    year = (params[:year] || now.year).to_i
    month = (params[:month] || now.month).to_i

    @calendar = Calendar.new(year, month, current_user)
  end
end
