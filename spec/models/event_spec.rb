# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  subject(:event) { create(:event, :with_attendees, :with_hotspots) }

  it { is_expected.to(validate_presence_of(:name)) }
  it { is_expected.to(validate_presence_of(:start_time)) }
  it { is_expected.to(validate_presence_of(:end_time)) }
  it { is_expected.to belong_to(:main_entrance).class_name('Experience') }

  describe '#publish' do
    before do
      event.publish
    end

    it 'publishes configuration' do
      expect(Redis.current.hget("event.#{event.key}", 'main_entrance')).to eq event.main_entrance.path
      expect(Redis.current.hget("event.#{event.key}", 'start_time')).to eq (event.start_time.to_i * 1000).to_s
      expect(Redis.current.hget("event.#{event.key}", 'end_time')).to eq (event.end_time.to_i * 1000).to_s

      event.attendees.each do |attendee|
        expect(Redis.current.hget(attendee.attendees_key, attendee.email)).to eq attendee.to_json
      end
      event.hotspots.each do |hotspot|
        expect(Redis.current.hget(hotspot.hotspots_key, hotspot.external_id)).to eq hotspot.to_json
      end
    end
  end
end
