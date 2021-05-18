# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hotspot, type: :model do
  subject(:hotspot) { create(:hotspot) }

  let(:event) { hotspot.event }
  let(:client) { event.client }

  describe '#as_json' do
    it 'returns appropriate hash' do
      expect(hotspot.as_json[:id]).to eq(hotspot.external_id)
      expect(hotspot.as_json[:client]).to eq(client.slug)
      expect(hotspot.as_json[:event]).to eq(event.slug)
      expect(hotspot.as_json[:tooltip]).to eq(hotspot.tooltip)
      expect(hotspot.as_json[:type]).to eq(hotspot.type)
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
