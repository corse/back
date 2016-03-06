# == Schema Information
#
# Table name: courses
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  status     :integer          default(0)
#  client_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Course Model
class Course < ApplicationRecord
  belongs_to :client
  has_many :assignments
end
