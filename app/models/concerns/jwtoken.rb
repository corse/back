# module for model with JWT
module Jwtoken
  extend ActiveSupport::Concern

  class_methods do
    def find_by_pw_reset_jwt(token)
      find_by_jwt token
    end

    def find_by_confirmation_jwt(token)
      find_by_jwt token
    end

    def find_by_jwt(token)
      payloader = decode_jwt token
      find payloader[0]['id']
    rescue JWT::DecodeError
      false
    end

    def decode_jwt(token, key = Rails.application.secrets['secret_key_base'])
      JWT.decode token, key, 'HS384'
    end
  end

  def jwt(hash = payload, key = Rails.application.secrets['secret_key_base'])
    JWT.encode hash, key, 'HS384'
  end

  def payload
    @payload ||= default_payload
  end

  private

  def default_payload
    { exp: (Time.zone.now + 1.week).to_i }
  end
end
