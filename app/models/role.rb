# == Schema Information
#
# Table name: roles
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  resource_type :string
#  resource_id   :integer
#  created_at    :datetime
#  updated_at    :datetime
#

# Rol based Authorization
class Role < ApplicationRecord
  has_many :users_roles, as: :role
  has_many :users, through: :users_roles
  belongs_to :resource, polymorphic: true, optional: true
  validates :name, presence: true
end
