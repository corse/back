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

# Account JSON API
class AccountSerializer < ActiveModel::Serializer
  attributes :uid
  belongs_to :client
end
