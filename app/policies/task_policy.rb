class TaskPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5
  def index?
    true
  end

  def show?
    user can see is own pages
    record.user == user  # || user.friends.include?(record.user) --for friend feature
  end

  def create?
    true # all user can create task
  end

  def update?
    user can only modify is own task
    record.user == user
  end

  def edit?
    update?
  end

  def destroy?
    record.user == user
  end
end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
    #def resolve # add a friend ?

      #scope.where(user: [user])  + user.friends
    #end
  end
end
