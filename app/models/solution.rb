# == Schema Information
#
# Table name: solutions
#
#  id            :integer          not null, primary key
#  assignment_id :integer
#  account_id    :integer
#  content       :text
#  grade         :integer          default(0)
#  submit_at     :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# Solution Model
class Solution < ApplicationRecord
  belongs_to :assignment
  belongs_to :account
end
