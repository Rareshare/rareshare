class NotificationsController < InternalController

  def show
    notification = Notification.find(params[:id])
    notification.seen!
    redirect_to polymorphic_path(notification.notifiable)
  end

end
