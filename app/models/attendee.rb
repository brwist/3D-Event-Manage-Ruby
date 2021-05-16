class Attendee < ApplicationRecord
  devise :database_authenticatable
  include BelongsToEvent

  validates :name, :email, presence: true

  def as_json(options = nil)
    {
      client: client_slug,
      event: event_slug,
      name: name,
      email: email,
      encrypted_password: encrypted_password
    }
  end
end
