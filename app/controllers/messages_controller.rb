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
    @message = UserMessage.new(
      messageable: messageable,
      sender: current_user,
      receiver: messageable.owner,
      body: message_params[:body]
    )

    if @message.save
      redirect_to polymorphic_path(@message.messageable), flash: { notice: "Message sent." }
    else
      render :new
    end
  end

  def new
    @message = UserMessage.new(messageable: messageable)
  end

  def reply
    @message = current_user.all_messages.find(params[:id])
    @message.reply! current_user, message_params[:body]
    redirect_to message_path(@message)
  end

  protected

  def message_params
    params.require(:message)
  end

  def messageable
    if params.has_key?(:tool_id)
      Tool.find(params[:tool_id])
    elsif params.has_key?(:booking_id)
      Booking.find(params[:booking_id])
    end
  end
end
