class NotificationsController < InternalController

  def index
    page = params[:page].try(:to_i) || 1
    @notifications = current_user.notifications.page(page)

    respond_to do |f|
      f.json do
        collection = @notifications.map do |n|
          views = n.notifiable.class.model_name.collection
          n.as_json.merge(
            html: render_to_string(partial: "#{views}/notification.html", object: n),
            seen: n.seen?,
            path: notification_path(n)
          )
        end

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
    redirect_to polymorphic_path(notification.notifiable)
  end

end
