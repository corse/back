# Client Authorization
class ClientPolicy < ApplicationPolicy
  def initialize(client, record)
    raise Pundit::NotAuthorizedError unless client.present?
    @client = client
    @record = record
  end

  def show?
    @client.id == record.id || @client.role?(:admin)
  end

  def create?
    @client.role?(:admin)
  end

  def update?
    @client.id == record.id || @client.role?(:admin)
  end

  def destroy?
    @client.id == record.id
  end
end
