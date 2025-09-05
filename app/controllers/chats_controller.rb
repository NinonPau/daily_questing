class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @messages = ChatMessage.order(created_at: :desc).limit(50)
   # model of chat that we order/et recup nb of sms and stock inside @
  end

  def create
    @message = ChatMessage.new(message_params)
    if @message.save
      redirect_to chats_path, notice: "Message envoyé !"  
    else
      redirect_to chats_path, alert: "Message  pas envoyé !"
    end
  end

  private

  def message_params
    params.require(:chat_message).permit(:author, :content)
  end
end
