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
    if user.class.name == 'Client'
      user.id == record.client_id
    else
      return false
    end
  end

  def update?
    (user == record) || (user == record.client)
  end

  def destroy?
    user == record.client
  end

  def self.scope(user)
    case user.class.to_s
    when 'Account'
      user.client.accounts
    when 'Client'
      user.accounts
    else
      Account.none
    end
  end
end
