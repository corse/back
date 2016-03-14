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
  include Jwtoken
  has_secure_password
  before_create :generate_cid
  before_create :generate_secret
  validates :email, uniqueness: true
  validates :name, uniqueness: true
  has_many :accounts
  has_many :courses

  def generate_cid
    self.cid = SecureRandom.uuid
  end

  def generate_secret
    self.secret = SecureRandom.hex(32)
  end

  def reset_password!(new_password)
    update password: new_password
  end

  def exchange_jwt_with(token)
    account = JWT.decode(token, secret, 'HS384')[0]
    raise JWT::DecodeError unless account['cid'] == cid
    JWT.encode account, Rails.application.secrets['secret_key_base'], 'HS384'
  end

  def default_payload
    load = { id: id, email: email }
    load[:aud] = Rails.application.secrets['default_url_options']['host']
    load[:exp] = Time.zone.now.weeks_ago(-1).to_i
    load
  end
end
