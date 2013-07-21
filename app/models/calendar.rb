class Calendar
  include ActiveAttr::Model

  attribute :year, type: Integer
  attribute :month, type: Integer
  attribute :user

  def new_record?; false; end

  def weeks
    (start_of_calendar..end_of_calendar).to_a.in_groups_of(7)
  end

  def start_of_month
    Date.new(self.year, self.month, 1)
  end

  def start_of_calendar
    start_of_month.beginning_of_week
  end

  def end_of_month
    start_of_month.end_of_month
  end

  def end_of_calendar
    end_of_month.end_of_week
  end

  def next
    next_month = start_of_month + 1.month
    Calendar.new(year: next_month.year, month: next_month.month, user: self.user)
  end

  def prev
    prev_month = start_of_month - 1.month
    Calendar.new(year: prev_month.year, month: prev_month.month, user: self.user)
  end

  def to_param
    start_of_month.strftime("%Y-%m")
  end

  def title
    start_of_month.strftime("%B %Y")
  end

  def bookings
    @bookings ||= Booking.joins(:tool)
      .where("renter_id = ? OR tools.owner_id = ?", self.user.id, self.user.id)
      .where("deadline >= ? AND deadline <= ?", start_of_month, end_of_month)
      .all
  end

  def days_of_week
    %w{S M Tu W Th F S}
  end

  def bookings_by_date
    @bookings_by_date ||= bookings.group_by {|b| b.deadline.to_date}
  end

end
