module CalendarHelper
  def date_class_for(calendar, date)
    classes = []

    classes << "bad_month" if date.month != calendar.month
    classes << "today" if date == Date.today
    classes << "leases" if calendar.bookings_by_date.has_key?(date)

    classes.join " "
  end
end
