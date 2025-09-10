class Task < ApplicationRecord
  belongs_to :user
  has_many :task_participants, dependent: :destroy
  has_many :participants, through: :task_participants, source: :user
  after_create :add_creator_as_participant


  def today? # to check the date
      date == Date.today
  end

  def self.reset_for_today # task to reset the ToDo list
    Task.where.not(date: Date.today).destroy_all # delette the task of the date
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
end
