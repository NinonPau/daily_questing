# frozen_string_literal: true

class TaskPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    # L'utilisateur peut voir sa propre task ou celles de ses amis
    record.user == user || user.friends.include?(record.user)
  end

  def create?
    true # tout utilisateur peut créer ses tasks
  end

  def update?
    # L'utilisateur ne peut modifier que ses propres tasks
    record.user == user
  end

  def edit?
    update?
  end

  def destroy?
    record.user == user
  end

  class Scope < Scope
    def resolve

      scope.where(user: [user]) # + user.friends - to add with friend feature?
    end
  end
end
