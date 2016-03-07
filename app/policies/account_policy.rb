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
    return false unless user.class.name == 'Client'
    user.id == record.client_id
  end

  def update?
    (user == record) || (user == record.client)
  end

  def destroy?
    user == record.client
  end

  def self.scope(user)
    case user.class.name
    when 'Account'
      user.client.accounts
    when 'Client'
      user.accounts
    else
      Account.none
    end
  end
end
