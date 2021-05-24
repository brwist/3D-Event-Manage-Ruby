# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id               :bigint           not null, primary key
#  end_time         :datetime
#  name             :string
#  slug             :string
#  start_time       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  client_id        :bigint           not null
#  main_entrance_id :bigint
#
# Indexes
#
#  index_events_on_client_id         (client_id)
#  index_events_on_main_entrance_id  (main_entrance_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (main_entrance_id => rooms.id)
#
require 'rails_helper'

RSpec.describe Event, type: :model do
  subject(:event) { create(:event, :with_attendees, :with_hotspots, :with_labels) }

  it { is_expected.to have_many(:attendees).dependent(:destroy) }
  it { is_expected.to have_many(:hotspots).dependent(:destroy) }
  it { is_expected.to have_many(:labels).dependent(:destroy) }
  it { is_expected.to(validate_presence_of(:name)) }
  it { is_expected.to(validate_presence_of(:start_time)) }
  it { is_expected.to(validate_presence_of(:end_time)) }
  it { is_expected.to belong_to(:main_entrance).class_name('Room') }

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

      event.labels.each do |label|
        expect(Redis.current.hget(label.labels_key, label.external_id)).to eq label.to_json
      end
    end
  end
end
