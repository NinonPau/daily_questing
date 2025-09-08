class AddCreatorToChatRooms < ActiveRecord::Migration[7.1]
  def change
    add_reference :chat_rooms, :creator, foreign_key: { to_table: :users }
  end
end
