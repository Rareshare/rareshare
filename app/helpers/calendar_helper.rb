module CalendarHelper
  def date_class_for(calendar, date)
    classes = []

    classes << "bad_month" if date.month != calendar.month
    classes << "today" if date.day == Time.zone.now.day
    classes << "leases" if date.day % 9 == 0 # calendar.leases_by_date[date].present?

    classes.join " "
  end
end
