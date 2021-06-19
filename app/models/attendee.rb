# frozen_string_literal: true

# == Schema Information
#
# Table name: attendees
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string           default(""), not null
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  event_id               :bigint           not null
#
# Indexes
#
#  index_attendees_on_email_and_event_id    (email,event_id) UNIQUE
#  index_attendees_on_event_id              (event_id)
#  index_attendees_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
class Attendee < ApplicationRecord
  include BelongsToEvent

  devise :database_authenticatable, :recoverable, :validatable

  validates :name, :email, presence: true
  validates :email, uniqueness: { scope: :event_id }

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

  def self.unpublish(event_key)
    Redis.current.del("hotspot.#{event_key}")
  end

  def publish
    Redis.current.hset(attendees_key, email, to_json)
  end

  def initials
    name
      .split(/\s/).select(&:present?).first(2).compact
      .map { |part| part.first.upcase }.join
  end

  # Hack to get around the Validatable email uniqueness validation
  def will_save_change_to_email?
    false
  end
end
