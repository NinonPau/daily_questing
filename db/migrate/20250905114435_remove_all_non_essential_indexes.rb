class RemoveAllNonEssentialIndexes < ActiveRecord::Migration[7.1]
  def change
    # chat_messages
    remove_index :chat_messages, :chat_room_id, if_exists: true
    remove_index :chat_messages, :sender_id, if_exists: true

    # chat_room_users
    remove_index :chat_room_users, :chat_room_id, if_exists: true
    remove_index :chat_room_users, :user_id, if_exists: true

    # chat_rooms
    remove_index :chat_rooms, :creator_id, if_exists: true

    # friendships
    remove_index :friendships, :friend_id, if_exists: true
    remove_index :friendships, :user_id, if_exists: true

    # messages
    remove_index :messages, :recipient_id, if_exists: true
    remove_index :messages, :sender_id, if_exists: true

    # tasks
    remove_index :tasks, :user_id, if_exists: true

    # user_moods
    remove_index :user_moods, :user_id, if_exists: true
  end
end
