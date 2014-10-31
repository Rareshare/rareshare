class NotificationMailer < ActionMailer::Base
  helper :application, :glyph
  default from: "RareShare <no-reply@rare-share.com>"

  def question_asked(notification_id)
    # to tool owner
    load_common_models notification_id

    if @user.can_email_status?
      mail to: @user.email, subject: "New Question about Booking #{@booking.id} for #{@notification.tool_name}"
    end
  end

  def booking_cancelled(notification_id)
    # to whoever didn't cancel
    load_common_models notification_id

    if @user.can_email_status?
      mail to: @user.email, subject: "Booking #{@booking.id} for #{@notification.tool_name} was cancelled"
    end
  end

  def booking_confirmed(notification_id)
    # to buyer
    load_common_models notification_id

    if @user.can_email_status?
      mail to: @user.email, subject: "Your Booking for #{@notification.tool_name} was approved"
    end
  end

  def booking_request(notification_id)
    # to tool owner
    load_common_models notification_id

    if @user.can_email_status?
      mail to: @user.email, subject: "New Booking Request for #{@notification.tool_name}"
    end
  end

  def booking_finalized(notification_id)
    load_common_models notification_id
    @buyside = @booking.renter? @user
    @currency = @tool.currency

    if @user.can_email_status?
      attachments['terms.pdf'] = @tool.terms_document.pdf.file.read
      mail to: @user.email, subject: "#{@buyside ? 'Your' : 'The'} Booking for #{@notification.tool_name} is Final"
    end
  end

  def booking_processing(notification_id)
    load_common_models notification_id

    if @user.can_email_status?
      mail to: @user.email, subject: "Work has started on your booking for #{@notification.tool_name}"
    end
  end

  def booking_completed(notification_id)
    load_common_models notification_id

    if @user.can_email_status?
      mail to: @user.email, subject: "Work has completed on your booking for #{@notification.tool_name}"
    end
  end

  def email(notification_id)
    load_common_models notification_id

    if @user.can_email_status?
      mail to: @user.email, subject: "Your booking has been updated"
    end
  end

  def tool_question_asked(notification_id)
    load_common_models notification_id

    @other_user = @notification.notifiable.sender

    if @user.can_email_status?
      mail to: @user.email, subject: "New Question about #{@notification.tool_name}", template_name: :question_asked
    end
  end

  private

  def load_common_models(notification_id)
    @notification = Notification.find notification_id

    @body = @notification.body
    @user = @notification.user

    #TODO: This url calculation is stinky and not DRY (duplicated in the NotificationsController)... must fix!
    @url = @notification.notifiable.is_a?(UserMessage) ? message_url(@notification.notifiable) : polymorphic_url(@notification.notifiable)

    if tool_id = @notification.properties["tool_id"]
      @tool = Tool.find tool_id
    end

    if booking_id = @notification.properties["booking_id"]
      @booking = Booking.find booking_id
      @other_user = @booking.opposite_party_to @user
    end

  end

end
