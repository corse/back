# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  client_id  :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Profile Model
class Profile < ApplicationRecord
  belongs_to :client
end
