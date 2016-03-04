# == Schema Information
#
# Table name: clients
#
#  id                   :integer          not null, primary key
#  name                 :string           not null
#  email                :string           not null
#  password_digest      :string
#  cid                  :string           not null
#  secret               :string           not null
#  scopes               :string           default(""), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#

require 'test_helper'

# Client Model Test
class ClientTest < ActiveSupport::TestCase
  setup do
    @client = clients(:one)
  end

  test 'should auto generate cid and secret on creation' do
    client = Client.new name: 'test', email: 'test@s.co', password: 'changeme'
    assert client.save
    assert_not_nil client.cid
    assert_not_nil client.secret
  end

  test 'client should have unique email' do
    client = Client.new email: @client.email, password: 'test', name: 'mmsdccsd'
    assert_not client.save
  end
end
