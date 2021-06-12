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
require 'rails_helper'

RSpec.describe Attendee, type: :model do
  subject(:attendee) { create(:attendee) }

  it { is_expected.to(validate_presence_of(:name)) }
  it { is_expected.to(validate_presence_of(:email)) }

  describe '#as_json' do
    it 'exports as json' do
      expect(attendee.as_json[:client]).to eq attendee.client_slug
      expect(attendee.as_json[:event]).to eq attendee.event_slug
      expect(attendee.as_json[:name]).to eq attendee.name
      expect(attendee.as_json[:email]).to eq attendee.email
      expect(attendee.as_json[:encrypted_password]).to eq attendee.encrypted_password
    end
  end

  describe '#publish' do
    it 'publishes to redis' do
      attendee.publish
      expect(Redis.current.hget("attendee.#{attendee.event_key}", attendee.email)).to eq attendee.to_json
    end
  end
end
