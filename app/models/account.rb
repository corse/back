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
  has_many :courses, through: :client

  def self.find_or_create_by_jwt(token)
    secret = Rails.application.secrets['secret_key_base']
    payloader = JWT.decode(token, secret, 'HS384')[0]
    client = Client.find_by cid: payloader['cid']
    client.accounts.find_or_create_by uid: payloader['uid']
  rescue JWT::DecodeError
    nil
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
