class MessagesController < InternalController

  def index
    @messages = current_user.received_messages(limit: 10).order("created_at DESC")
  end

  def show
    @message = UserMessage.find(params[:id])

    if can? :read, @message
      current_user.acknowledge_message!(@message)

      if @message.messageable.present?
        redirect_to @message.messageable
      elsif !@message.first?
        redirect_to message_path(@message.originating_message_id, anchor: "message-#{@message.id}")
      end
    else
      redirect_to :back, flash: { error: "You do not have permission to read this message." }
    end
  end

  def create
  end

  def reply
    @message = current_user.all_messages.find(params[:id])
    @message.reply! current_user, message_params[:body]
    redirect_to message_path(@message)
  end

  private

  def message_params
    params.require(:message)
  end
end
