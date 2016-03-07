# Course Authorization
class CoursePolicy < ApplicationPolicy
  def initialize(user, record)
    # raise Pundit::NotAuthorizedError unless user.present?
    @user = user
    @record = record
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    return true if user == record.client
    user.try :role?, :teacher, record
  end

  def self.scope(user)
    case user.class.name
    when 'Account'
      user.client.courses
    when 'Client'
      user.courses
    else
      Course.none
    end
  end
end
