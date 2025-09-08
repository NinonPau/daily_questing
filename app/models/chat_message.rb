class ChatMessage < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: :user_id
  belongs_to :chat_room

  validates :content, presence: true
end
