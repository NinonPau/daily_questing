class User < ApplicationRecord
  # --- Associations avec les tâches ---
  has_many :tasks, dependent: :destroy
  has_many :task_participants, dependent: :destroy
  has_many :joined_tasks, through: :task_participants, source: :task

  # --- Relations d’amitié ---
  has_many :friendships, dependent: :destroy
  has_many :friends, -> { where(friendships: { status: "accepted" }) }, through: :friendships

  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :inverse_friends, -> { where(friendships: { status: "accepted" }) }, through: :inverse_friendships, source: :user

  # Invitations envoyées/en attente
  has_many :sent_pending_friendships, -> { where(status: "pending") }, class_name: "Friendship", foreign_key: "user_id"
  has_many :received_pending_friendships, -> { where(status: "pending") }, class_name: "Friendship", foreign_key: "friend_id"

  has_many :sent_pending_invitations, through: :sent_pending_friendships, source: :friend
  has_many :received_pending_invitations, through: :received_pending_friendships, source: :user

  # --- Chat ---
  has_many :chat_messages, foreign_key: :sender_id, dependent: :destroy
  has_many :chat_rooms, through: :chat_messages
  has_many :created_chat_rooms, class_name: "ChatRoom", foreign_key: :creator_id, dependent: :destroy

  # --- Devise ---
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # --- Humeur ---
  has_one :user_mood, dependent: :destroy
  after_create :set_default_mood

  # --- Méthodes personnalisées ---

  # Ajoute le créateur d’une tâche comme participant
  def add_creator_as_participant(task)
    task.task_participants.find_or_create_by(user: self, status: "accepted")
  end

  # Retourne les tâches où je suis invité
  def invited_tasks
    Task.where(partner_id: id)
  end

  # Ajoute de l’XP avec bonus de mood
  def add_xp(amount)
    current_total = total_xp || 0
    bonus = user_mood&.xp_bonus || 1.0
    update(total_xp: current_total + (amount.to_f * bonus))
  end

  # Calcule le niveau actuel selon l’XP
  def current_level
    case total_xp
    when 0..250     then 1
    when 251..800   then 2
    when 801..2000  then 3
    when 2001..4600 then 4
    when 4601..10000 then 5
    when 10001..22000 then 6
    when 22001..48000 then 7
    when 48001..104000 then 8
    when 104001..224000 then 9
    when 224001..480000 then 10
    else
      10
    end
  end

  # Progression XP dans le niveau
  def xp_progress_percent
    xp = total_xp || 0  # si nil → 0

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

    range = levels[current_level]
    min, max = range.begin, range.end

    xp_into_level = xp - min
    xp_required   = max - min
    percent       = (xp_into_level.to_f / xp_required) * 100

    {
      percent: percent.round(2),
      remaining: [max - xp, 0].max
    }
  end

  # Invitations en attente liées aux tâches
  def pending_invitations
    task_participants.where(status: "pending").map(&:task)
  end

  private

  def set_default_mood
    create_user_mood(xp_bonus: 1.0) unless user_mood.present?
  end
end
