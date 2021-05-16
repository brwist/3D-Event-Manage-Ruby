# frozen_string_literal: true

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
      expect(Redis.current.hget("attendees.#{attendee.event_key}", attendee.email)).to eq attendee.to_json
    end
  end
end
