# frozen_string_literal: true

class TaskPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    # user can see their own tasks
    record.user == user
    # or allow friends: record.user == user || user.friends.include?(record.user)
  end

  def create?
    true # all users can create tasks
  end

  def update?
    # user can only modify their own task
    record.user == user
  end

  def edit?
    update?
  end

  def destroy?
    record.user == user
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      # Adjust this as needed
      scope.where(user: user)
    end
  end
end

