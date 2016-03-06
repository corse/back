# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  client_id  :integer          not null
#  uid        :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
