class AddCreatorToChatRooms < ActiveRecord::Migration[7.1]
  def change
    add_reference :chat_rooms, :creator, null: false, foreign_key: true
  end
end
