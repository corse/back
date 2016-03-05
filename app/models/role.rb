# Rol based Authorization
class Role < ApplicationRecord
  has_many :users_roles, as: :role
  has_many :users, through: :users_roles
  belongs_to :resource, polymorphic: true, optional: true
  validates :name, presence: true
end
