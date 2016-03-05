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

# Client Model
class Client < ApplicationRecord
  include Confirmable
  include Rolify
  has_secure_password
  attr_writer :payload
  before_create :generate_cid
  before_create :generate_secret
  validates :email, uniqueness: true
  validates :name, uniqueness: true

  def generate_cid
    self.cid = SecureRandom.uuid
  end

  def generate_secret
    self.secret = SecureRandom.hex(32)
  end

  def reset_password!(new_password)
    update password: new_password
  end

  def self.find_by_pw_reset_jwt(token)
    find_by_jwt token
  end

  def self.find_by_confirmation_jwt(token)
    find_by_jwt token
  end

  def self.find_by_jwt(token)
    payloader = decode_jwt token
    find payloader[0]['id']
  rescue JWT::DecodeError
    false
  end

  def jwt(hash = payload)
    secret = Rails.application.secrets['secret_key_base']
    JWT.encode(hash || payload, secret, 'HS384')
  end

  def self.decode_jwt(token)
    secret = Rails.application.secrets['secret_key_base']
    JWT.decode(token, secret, 'HS384')
  end

  def payload
    @payload ||= { id: id, email: email, exp: (Time.zone.now + 1.week).to_i }
  end
end
