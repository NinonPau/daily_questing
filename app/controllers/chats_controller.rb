class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @messages = @chat_room.chat_messages.order(created_at: :desc).limit(50)
   # model of chat that we order/et recup nb of sms and stock inside @
  end

  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @message = @chat_room.chat_messages.build(message_params)
    @message.user = current_user
    if @message.save
      redirect_to chats_path, notice: "Message sent!"
    else
      redirect_to chats_path, alert: "Message not sent!"
    end
  end

  private

  def message_params
    params.require(:chat_message).permit(:content)
  end
end
