# Rol based Authorization
class UsersRole < ApplicationRecord
  belongs_to :user, polymorphic: true
  belongs_to :role
end
