class ChatMessage < ApplicationRecord
  belongs_to :sender, class_name: "User", foreign_key: :sender_id
  belongs_to :chat_room

  validates :content, presence: true
end
