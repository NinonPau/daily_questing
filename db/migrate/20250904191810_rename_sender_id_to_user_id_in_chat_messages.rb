class RenameSenderIdToUserIdInChatMessages < ActiveRecord::Migration[7.1]
  def change
    rename_column :chat_messages, :sender_id, :user_id
  end
end
