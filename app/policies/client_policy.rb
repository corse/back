# Client Authorization
class ClientPolicy < ApplicationPolicy
  def initialize(client, record)
    @client = client
    @record = record
  end

  def show?
    true
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
