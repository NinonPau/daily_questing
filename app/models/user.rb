class User < ApplicationRecord
  has_many :tasks
  # current user accept many frineds that actualy accept my invitation
  has_many :friendships
  has_many :friends, -> { where(friendships: { status: "accepted" }) }, through: :friendships # way to do condition insinde a has_many
  # i am on many friends list if they accept my invitation
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, -> { where(friendships: { status: "accepted" }) }, through: :inverse_friendships, source: :user
  # allow current_user.friends> friend i accepted / current_user.inverse_friends > the one that add me
  has_many :chat_messages, foreign_key: :sender_id, dependent: :destroy
  has_many :chat_rooms, through: :chat_messages
  has_many :created_chat_rooms, class_name: "ChatRoom", foreign_key: :creator_id, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :user_mood

  def add_xp(amount)
    current_total = total_xp || 0
    update(total_xp: current_total + amount.to_f)
  end

  def mood_type_or_default
    user_mood&.mood_type || "Unknown"
  end

end
