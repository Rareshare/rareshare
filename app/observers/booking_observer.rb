class BookingObserver < ActiveRecord::Observer

  def after_save(booking)
    create_booking_log_for booking
    notify_users_of_state_change_in booking
  end

  protected

  def create_booking_log_for(booking)
    booking.booking_logs.create(state: booking.state, updated_by: booking.last_updated_by)
  end

  def notify_users_of_state_change_in(booking)
    notification_method = "notify_booking_#{booking.state}"

    if respond_to?(notification_method)
      self.send notification_method, booking
    end
  end

  def notify_booking_pending(booking)
    message_body = I18n.t("bookings.notify.pending",
      tool_name: booking.tool.display_name,
      renter_name: booking.renter.display_name,
      description: booking.sample_description
    )

    booking.append_message(
      receiver: booking.owner,
      sender: booking.renter,
      body: message_body
    )
  end

  def notify_booking_confirmed(booking)
    message_body = I18n.t("bookings.notify.confirmed",
      owner_name: booking.owner.display_name
    )

    booking.append_message(
      receiver: booking.renter,
      sender: booking.owner,
      body: message_body
    )
  end

  def notify_booking_cancelled(booking)
    message_body = I18n.t("bookings.notify.cancelled")

    booking.append_message(
      receiver: booking.owner,
      sender: booking.renter,
      body: message_body
    )
  end

  def notify_booking_denied(booking)
    message_body = I18n.t("bookings.notify.denied",
      owner_name: booking.owner.display_name
    )

    booking.append_message(
      receiver: booking.renter,
      sender: booking.owner,
      body: message_body
    )
  end

end
