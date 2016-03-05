# Client Authorization
class ClientPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def initialize(user, record)
    raise Pundit::NotAuthorizedError unless user.present?
    @user = user
    @record = record
  end

  def show?
    @user.id == record.id || @user.role?(:admin)
  end

  def create?
    @user.role?(:admin)
  end

  def update?
    @user.id == record.id || @user.role?(:admin)
  end

  def destroy?
    @user.id == record.id
  end
end
