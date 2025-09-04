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
# frozen_string_literal: true

#class ApplicationPolicy

  #def index?
    #true
  #end

  #def show?
    # user can see is own pages
    #record.user == user  # || user.friends.include?(record.user) --for friend feature
  #end

  #def create?
    #true # all user can create task
  #end

  #def update?
    # user can only modify is own task
   # record.user == user
 # end

  #def edit?
    #update?
  #end

  #def destroy?
    #record.user == user
  #end

# class Scope < Scope #- tadd with friend feature?
    #def resolve

      #scope.where(user: [user])  + user.friends
    #end
  #end
#end
