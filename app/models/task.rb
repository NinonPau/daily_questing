class Task < ApplicationRecord
  belongs_to :user

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
end

