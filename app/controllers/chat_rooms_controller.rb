class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Liste de tous les chats ouverts
    @chat_rooms = ChatRoom.all
  end

  def show
    # Affiche les messages d’un chat spécifique
    @chat_room = ChatRoom.find(params[:id])
    @messages = @chat_room.chat_messages.order(created_at: :asc)
    @new_message = ChatMessage.new
  end

  def create_message
    @chat_room = ChatRoom.find(params[:id])
    @message = @chat_room.chat_messages.build(message_params)
    @message.sender = current_user

    if @message.save
      redirect_to chat_room_path(@chat_room)
    else
      redirect_to chat_room_path(@chat_room), alert: "Could not send message."
    end
  end

  private

  def message_params
    params.require(:chat_message).permit(:content)
  end
end
