# Solution Authorization
class SolutionPolicy < ApplicationPolicy
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
    record.submit_at.nil?
  end

  def destroy?
    record.submit_at.nil?
  end
end
