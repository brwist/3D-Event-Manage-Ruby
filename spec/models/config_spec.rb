# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Config, type: :model do
  it { is_expected.to validate_uniqueness_of(:name) }

  describe '.get' do
    subject(:config) { described_class.create!(name: 'a setting', value: 'a value') }

    it 'returns the right value' do
      expect(described_class.get(config.name)).to eq('a value')
    end

    it 'returns empty when value is not found' do
      expect(described_class.get('bla')).to eq('')
    end

    it 'returns default when value is not found' do
      expect(described_class.get('bla', default: 'hello')).to eq('hello')
    end
  end
end
