# == Schema Information
#
# Table name: users_roles
#
#  user_type :string
#  user_id   :integer
#  role_id   :integer
#

# Rol based Authorization
class UsersRole < ApplicationRecord
  belongs_to :user, polymorphic: true
  belongs_to :role
end
