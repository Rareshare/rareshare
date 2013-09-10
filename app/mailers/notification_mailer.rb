class NotificationMailer < ActionMailer::Base
  default from: "RareShare <no-reply@rare-share.com>"

  def email(notification_id)
    notification = Notification.find(notification_id)

    @body = t("bookings.notify.#{notification.properties["state"]}", tool_name: notification.notifiable.tool.display_name).html_safe
    @user = notification.user
    @url  = polymorphic_url(notification.notifiable)

    if @user.can_email_status
      mail to: @user.email, subject: "Your booking has been updated"
    end
  end
end
