class NotificationMailer < ActionMailer::Base
  default from: "RareShare <no-reply@rare-share.com>"

  def email(notification_id)
    @notification = Notification.find(notification_id)

    @body = @notification.body
    @user = @notification.user
    @url  = polymorphic_url(@notification.notifiable)

    if tool_id = @notification.properties["tool_id"]
      @tool = Tool.find(tool_id)
    end

    if @user.can_email_status
      mail to: @user.email, subject: "Your booking has been updated"
    end
  end
end
