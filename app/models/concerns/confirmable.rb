# module for model with confirmed_at
module Confirmable
  extend ActiveSupport::Concern

  included do
    scope :confirmed, -> { where.not(confirmed_at: nil) }
    scope :unconfirmed, -> { where(confirmed_at: nil) }
  end

  def confirm!(from = nil)
    if confirmed?
      true # prevent user from confirming multiple times
    else
      return false if from && from != email
      update(confirmed_at: Time.zone.now)
    end
  end

  def unconfirm!
    if confirmed?
      update confirmed_at: nil
    else
      true # prevent user from confirming multiple times
    end
  end

  def confirmed?
    confirmed_at != nil
  end
end
