class NotificationsController < InternalController

  def index
    page = params[:page].try(:to_i) || 1
    @notifications = current_user.notifications.page(page)

    respond_to do |f|
      f.json do
        collection = @notifications.map do |n|
          unless n.notifiable.nil?
            views = n.notifiable.class.model_name.collection
            n.as_json.merge(
              html: render_to_string(partial: "#{views}/notification.html", object: n),
              seen: n.seen?,
              path: notification_path(n)
            )
          end
        end.compact

        render json: {
          notifications: collection,
          next: notifications_path(page: page + 1, format: :json)
        }
      end

      f.html {}
    end
  end

  def show
    notification = Notification.find(params[:id])
    notification.seen!
    #TODO: This path calculation is stinky and not DRY (duplicated in the NotificationMailer)... must fix!
    path = notification.notifiable.is_a?(UserMessage) ? message_path(notification.notifiable) : polymorphic_path(notification.notifiable)
    redirect_to path
  end

end
