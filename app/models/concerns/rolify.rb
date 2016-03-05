# module for model with roles
module Rolify
  extend ActiveSupport::Concern

  included do
    has_many :users_roles, as: :user
    has_many :roles, through: :users_roles
  end

  def add_role(name, resource = nil)
    roles.create name: name, resource: resource
  end

  def role?(name, resource = nil)
    roles.find_by(name: name, resource: resource).present?
  end
end
