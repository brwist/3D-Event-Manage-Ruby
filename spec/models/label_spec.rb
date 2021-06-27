# frozen_string_literal: true

# == Schema Information
#
# Table name: labels
#
#  id          :bigint           not null, primary key
#  text        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  event_id    :bigint           not null
#  external_id :string
#  token_id    :bigint
#
# Indexes
#
#  index_labels_on_event_id                  (event_id)
#  index_labels_on_event_id_and_external_id  (event_id,external_id) UNIQUE
#  index_labels_on_token_id                  (token_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (token_id => tokens.id)
#
require 'rails_helper'

RSpec.describe Label, type: :model do
  subject(:label) { create(:label) }

  let(:event) { label.event }
  let(:client) { event.client }

  it { is_expected.to belong_to(:token).optional }
  it { is_expected.to validate_uniqueness_of(:external_id).scoped_to(:event_id) }

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

  describe '#unpublish' do
    it 'unpublishes from redis' do
      label.publish
      Label.unpublish(label.event_key)
      expect(Redis.current.exists("label.#{label.event_key}")).to eq 0
    end
  end

  describe '.labels_key' do
    it 'returns correct key' do
      expect(label.labels_key).to include('label.')
    end
  end
end
