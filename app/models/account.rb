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

# Account Model
class Account < ApplicationRecord
  attr_writer :cid
  include Jwtoken
  include Rolify
  belongs_to :client

  def self.init_by_jwt(token)
    secret = Rails.application.secrets['secret_key_base']
    payload = JWT.decode(token, secret, 'HS384')[0]
    new(uid: payload['uid'].to_i, cid: payload['cid'])
  end

  def cid
    @cid ||= client.cid
  end

  private

  def default_payload
    load = { uid: uid, cid: cid }
    load[:aud] = Rails.application.secrets['default_url_options']['host']
    load[:exp] = Time.zone.now.weeks_ago(-1).to_i
    load
  end
end
