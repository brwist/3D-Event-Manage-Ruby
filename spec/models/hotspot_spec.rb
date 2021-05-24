# frozen_string_literal: true

# == Schema Information
#
# Table name: hotspots
#
#  id              :bigint           not null, primary key
#  destination_url :string
#  mime_type       :string
#  presign         :boolean          default(FALSE)
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  content_id      :bigint
#  event_id        :bigint           not null
#  external_id     :string
#  token_id        :bigint
#
# Indexes
#
#  index_hotspots_on_content_id  (content_id)
#  index_hotspots_on_event_id    (event_id)
#  index_hotspots_on_token_id    (token_id)
#
# Foreign Keys
#
#  fk_rails_...  (content_id => contents.id)
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (token_id => tokens.id)
#
require 'rails_helper'

RSpec.describe Hotspot, type: :model do
  subject(:hotspot) { create(:hotspot) }

  let(:event) { hotspot.event }
  let(:client) { event.client }

  it { is_expected.to belong_to(:token).optional }
  it { is_expected.to belong_to(:content).optional }

  describe '#as_json' do
    it 'returns appropriate hash' do
      expect(hotspot.as_json[:id]).to eq(hotspot.external_id)
      expect(hotspot.as_json[:client]).to eq(client.slug)
      expect(hotspot.as_json[:event]).to eq(event.slug)
      expect(hotspot.as_json[:type]).to eq(hotspot.type)
      expect(hotspot.as_json[:mime_type]).to eq(hotspot.mime_type)
      expect(hotspot.as_json[:presign]).to eq(hotspot.presign)
      expect(hotspot.as_json[:destination_url]).to eq(hotspot.destination_url)
    end
  end

  describe '#publish' do
    it 'publishes to redis' do
      hotspot.publish
      expect(Redis.current.hget("hotspot.#{hotspot.event_key}", hotspot.external_id)).to eq hotspot.to_json
    end
  end
end
