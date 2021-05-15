require 'rails_helper'

RSpec.describe Hotspot, type: :model do
  describe '#as_json' do
    let(:hotspot) { create(:hotspot) }
    let(:event) { hotspot.event }
    let(:client) { event.client }

    it 'returns appropriate hash' do
      expect(hotspot.as_json[:id]).to eq(hotspot.external_id)
      expect(hotspot.as_json[:client]).to eq(client.slug)
      expect(hotspot.as_json[:event]).to eq(event.slug)
      expect(hotspot.as_json[:tooltip]).to eq(hotspot.tooltip)
      expect(hotspot.as_json[:destination_url]).to eq(hotspot.destination_url)
    end
  end
end
