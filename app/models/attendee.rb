# frozen_string_literal: true

class Attendee < ApplicationRecord
  devise :database_authenticatable
  include BelongsToEvent

  validates :name, :email, presence: true

  def attendees_key
    "attendee.#{event_key}"
  end

  def as_json(_options = nil)
    {
      client: client_slug,
      event: event_slug,
      name: name,
      email: email,
      encrypted_password: encrypted_password
    }
  end

  def publish
    Redis.current.hset(attendees_key, email, to_json)
  end
end
