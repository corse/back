# == Schema Information
#
# Table name: assignments
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  deadline   :datetime
#  content    :text
#  course_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Assignment Model
class Assignment < ApplicationRecord
  belongs_to :course
  has_many :solutions
end
