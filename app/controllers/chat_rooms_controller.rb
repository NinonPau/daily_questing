class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  # Create a new chat room
  def create
    @chat_room = ChatRoom.new(chat_room_params) # no creator_id in schema
    @chat_room.creator = current_user
    if @chat_room.save
      @chat_room.users << current_user # Add current user as the "creator"
      redirect_to chat_room_path(@chat_room)
    else
      render status: :unprocessable_entity
    end
  end

  # List of chat rooms the current user is part of
  def index
    @chat_rooms = ChatRoom.joins(:users).where(users: { id: current_user.id })
  end

  # Show chat room with messages
  def show
    @chat_room = ChatRoom.find(params[:id])
    @messages = @chat_room.chat_messages.order(created_at: :asc)
    @new_message = ChatMessage.new
  end

  # Create a message in a chat room
  def create_message
    @chat_room = ChatRoom.find(params[:id])
    @message = ChatMessage.new(message_params)
    @message.chat_room = @chat_room
    @message.user = current_user # matches your schema column "user_id"

    if @message.save
      redirect_to chat_room_path(@chat_room)
    else
      redirect_to chat_room_path(@chat_room), alert: "Could not send message."
    end
  end

  # Destroy a chat room
  def destroy
    @chat_room = ChatRoom.find(params[:id])
    if @chat_room.users.creator == current_user
      @chat_room.destroy
      redirect_to chat_rooms_path, notice: "Chat deleted."
    else
      redirect_to chat_rooms_path, alert: "Only the creator can delete the chat."
    end
  end

  # Invite a user to a chat room — only allow first user as "creator"
  def invite
    @chat_room = ChatRoom.find(params[:id])
    if @chat_room.creator == current_user
      user_to_invite = User.find(params[:user_id])
      @chat_room.users << user_to_invite unless @chat_room.users.include?(user_to_invite)
      redirect_to chat_room_path(@chat_room), notice: "#{user_to_invite.username} has been invited."
    else
      redirect_to chat_room_path(@chat_room), alert: "Only the creator can invite users."
    end
  end

  private

  def chat_room_params
    params.require(:chat_room).permit(:name)
  end

  def message_params
    params.require(:chat_message).permit(:content)
  end
end
