# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  subject(:label) { create(:label) }

  let(:event) { label.event }
  let(:client) { event.client }

  it { is_expected.to belong_to(:token).optional }

  describe '#as_json' do
    it 'returns appropriate hash' do
      expect(label.as_json[:id]).to eq(label.external_id)
      expect(label.as_json[:client]).to eq(client.slug)
      expect(label.as_json[:text]).to eq(label.text)
    end
  end

  describe '#publish' do
    it 'publishes to redis' do
      label.publish
      expect(Redis.current.hget("label.#{label.event_key}", label.external_id)).to eq label.to_json
    end
  end
end
