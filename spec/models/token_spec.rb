# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Token, type: :model do
  subject(:token) { create(:token) }

  let(:event) { create(:event) }
  let(:content) { create(:content) }
  let(:url) { Faker::Internet.url }
  let(:text) { Faker::Tea.variety }

  it { is_expected.to belong_to(:room) }

  describe '#create_url_hotspot' do
    it 'creates url hotspot' do
      expect {
        token.create_url_hotspot(event: event, url: url, text: text, type: :new_page)
      }.to change(Hotspot, :count)

      hotspot = Hotspot.last
      expect(hotspot.event).to eq(event)
      expect(hotspot.external_id).to eq(token.token)
      expect(hotspot.destination_url).to eq(url)
      expect(hotspot.type).to eq('new_page')

      label = Label.last
      expect(label.external_id).to eq(token.token)
      expect(label.text).to eq(text)
    end
  end

  describe '#create_label' do
    it 'creates corresponding label' do
      expect {
        token.create_label(event: event, text: text)
      }.to change(Label, :count)

      label = Label.last
      expect(label.external_id).to eq(token.token)
      expect(label.text).to eq(text)
    end
  end

  describe '#create_content_hotspot' do
    it 'creates url hotspot' do
      expect {
        token.create_content_hotspot(event: event, content: content, text: text)
      }.to change(Hotspot, :count)

      hotspot = Hotspot.last
      expect(hotspot.event).to eq(event)
      expect(hotspot.external_id).to eq(token.token)
      expect(hotspot.destination_url).to eq(content.file.key)
      expect(hotspot.type).to eq('display')
      expect(hotspot.mime_type).to eq('application/pdf')

      label = Label.last
      expect(label.external_id).to eq(token.token)
      expect(label.text).to eq(text)
    end
  end
end
