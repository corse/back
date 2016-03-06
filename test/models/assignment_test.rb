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

require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
