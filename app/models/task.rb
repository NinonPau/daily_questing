class Task < ApplicationRecord
  belongs_to :user
  has_many :task_participants, dependent: :destroy
  has_many :participants, through: :task_participants, source: :user

  after_update :give_xp_to_partner

  def today? # to check the date
      date == Date.today
  end

  def self.reset_for_today # task to reset the ToDo list
    Task.where.not(date: Date.today).delete_all # delette the task of the date
    #may want to make if statement if we want to keep random task
    User.find_each do |user|
      user.tasks.where(daily: true).each do |daily_task|
        user.tasks.create(
          name: daily_task.name,
          description: daily_task.description,
          daily: true,
          xp: daily_task.xp,
          completed: false,
          date: Date.today
        )
      end
    end
  end

  def invitation_accepted_by?(user)
    task_participants.exists?(user: user, status: "accepted")
  end

  def add_creator_as_participant
    task_participants.find_or_create_by(user: user, status: "accepted")
  end

  private

  def give_xp_to_partner
  # Only give XP if the task is completed
  if completed
    # Loop through all participants who accepted this task
    task_participants.where(status: "accepted").each do |tp|
      # Safely get the user associated with this participant
      user = tp.user
      next unless user.present?

      # Add the XP from this task to the user's total_xp
      new_total = (user.total_xp || 0) + xp
      user.update(total_xp: new_total)
    end
  end
end

end
