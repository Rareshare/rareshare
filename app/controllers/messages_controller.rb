class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @messages = current_user.received_messages(limit: 10)
  end

  def show
    @message = current_user.read_message(params[:id])
  end
end