# Account Authorization
class AccountPolicy < ApplicationPolicy
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
    true
  end

  def self.scope(user)
    Account
  end
end
