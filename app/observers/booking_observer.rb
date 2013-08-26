class BookingObserver < ActiveRecord::Observer

  def after_save(booking)
    booking.booking_logs.create(state: booking.state, updated_by: booking.last_updated_by)
    booking.notifications.create(user: booking.opposite_party_to(booking.last_updated_by), properties: { state: booking.state })
  end

end
