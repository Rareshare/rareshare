class CalendarController < InternalController
  def show
    if params[:id].present? && params[:id] =~ /(\d{4})-(\d{2})/
      year, month = [ $1, $2 ].map &:to_i
    else
      now = Date.today
      year, month = now.year, now.month
    end

    @calendar = Calendar.new(year, month, current_user)
  end
end
