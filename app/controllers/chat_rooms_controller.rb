class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat_room = current_user.created_chat_rooms.build(chat_room_params)# new chat room
    if @chat_room.save
      @chat_room.users << current_user # add current user to chat room
      redirect_to chat_room_path(@chat_room)
    else
      render status: :unprocessable_entity
    end
  end

  def index
    # Liste of chat wher the user is invited or create it
    @chat_rooms = ChatRoom.joins(:users).where(users: { id: current_user.id })
  end

  def show
    # Affiche les messages d’un chat spécifique
    @chat_room = ChatRoom.find(params[:id])
    @messages = @chat_room.chat_messages.order(created_at: :asc)
    @new_message = ChatMessage.new
  end

  def create_message
    @chat_room = ChatRoom.find(params[:id])

    @message = ChatMessage.new(message_params)
    @message.chat_room = @chat_room
    @message.sender = current_user

    if @message.save
      redirect_to chat_room_path(@chat_room)
    else
      redirect_to chat_room_path(@chat_room), alert: "Could not send message."
    end
  end

  def destroy
    @chat_room = ChatRoom.find(params[:id])
    if @chat_room.creator == current_user # only the creator can delete
      @chat_room.destroy
      redirect_to chat_rooms_path, notice: "Chat supprimé."
    else
      redirect_to chat_rooms_path, alert: "Vous n'avez pas le droit de supprimer ce chat."
    end
  end

  def invite
    @chat_room = ChatRoom.find(params[:id])
    if @chat_room.creator == current_user #only the creator can invite
      user_to_invite = User.find(params[:user_id])
      @chat_room.users << user_to_invite unless @chat_room.users.include?(user_to_invite)
      #check if invitee is not already in chat room and add him
      redirect_to chat_room_path(@chat_room), notice: "#{user_to_invite.username} invité."
      flash[:notice] = "#{user_to_invite.username} a bien été invité dans le chat."
    else
      redirect_to chat_room_path(@chat_room), alert: "Seul le créateur peut inviter."
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
