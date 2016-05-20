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

# Client JSON API
class ClientSerializer < ActiveModel::Serializer
  attribute :jwt, key: :token
  attributes :email, :cid, :secret, :name
end
