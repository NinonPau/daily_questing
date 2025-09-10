class User < ApplicationRecord
  has_many :tasks
  has_many :task_participants, dependent: :destroy
  has_many :joined_tasks, through: :task_participants, source: :task
  # current user accept many frineds that actualy accept my invitation
  has_many :friendships
  has_many :friends, -> { where(friendships: { status: "accepted" }) }, through: :friendships # way to do condition insinde a has_many
  # i am on many friends list if they accept my invitation
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, -> { where(friendships: { status: "accepted" }) }, through: :inverse_friendships, source: :user
  # Invitations en attente que j'ai envoyée
  has_many :received_pending_invitations, through: :received_pending_friendships, source: :user
  # allow current_user.friends> friend i accepted / current_user.inverse_friends > the one that add me
  has_many :chat_messages, foreign_key: :sender_id, dependent: :destroy
  has_many :chat_rooms, through: :chat_messages
  has_many :created_chat_rooms, class_name: "ChatRoom", foreign_key: :creator_id, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :user_mood

  after_create :set_default_mood

  def add_creator_as_participant
    task_participants.find_or_create_by(user: user, status: "accepted")
  end

  def invited_tasks
    Task.where(partner_id: id)
  end

  def add_xp(amount)
    current_total = total_xp || 0
    bonus = user_mood&.xp_bonus || 1.0
    update(total_xp: current_total + amount.to_f * bonus)
  end

 def current_level
  case total_xp
    when 0..250
     1
    when 251..800
     2
    when 801..2000
      3
    when 2001..4600
      4
    when 4601..10000
      5
    when 10001..22000
      6
    when 22001..48000
      7
    when 48001..104000
      8
    when 104001..224000
      9
    when 224001..480000
      10
  end
 end

 def xp_progress_percent
  levels = {
    1 => 0..250,
    2 => 251..800,
    3 => 801..2000,
    4 => 2001..4600,
    5 => 4601..10000,
    6 => 10001..22000,
    7 => 22001..48000,
    8 => 48001..104000,
    9 => 104001..224000,
    10 => 224001..480000
  }
  current_level_range = levels[current_level]
  min = current_level_range.begin
  max = current_level_range.end
  xp_into_level = total_xp - min
  xp_required = max - min
  percent = (xp_into_level.to_f / xp_required) * 100
   {
    percent: percent.round(2),
    remaining: (max - total_xp).round(0)
   }
 end



  def pending_invitations
    task_participants.where(status: "pending").map(&:task)
  end

  private

  def set_default_mood
    create_user_mood(xp_bonus: 1.0) unless user_mood.present?
  end

end
