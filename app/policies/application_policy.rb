# frozen_string_literal: true

class ApplicationPolicy
  
  def index?
    true
  end

  def show?
    # user can see is own pages
    record.user == user  # || user.friends.include?(record.user) --for friend feature
  end

  def create?
    true # all user can create task
  end

  def update?
    # user can only modify is own task
    record.user == user
  end

  def edit?
    update?
  end

  def destroy?
    record.user == user
  end

 # class Scope < Scope - tadd with friend feature?
   # def resolve

     # scope.where(user: [user])  + user.friends
    #end
  #end
end
