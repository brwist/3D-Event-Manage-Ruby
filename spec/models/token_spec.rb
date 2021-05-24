# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Token, type: :model do
  subject(:token) { create(:token) }

  let(:event) { create(:event) }
  let(:url) { Faker::Internet.url }

  it { is_expected.to belong_to(:room) }

  describe '#create_url_hotspot' do
    it 'creates url hotspot' do
      expect {
        token.create_url_hotspot(event: event, url: url)
      }.to change(Hotspot, :count)

      hotspot = Hotspot.last
      expect(hotspot.event).to eq(event)
      expect(hotspot.external_id).to eq(token.token)
      expect(hotspot.destination_url).to eq(url)
      expect(hotspot.type).to eq('redirect')
    end
  end
end
