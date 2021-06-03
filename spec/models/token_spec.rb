# frozen_string_literal: true

# == Schema Information
#
# Table name: tokens
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  token      :string           not null
#  type       :string           default("content")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  room_id    :bigint           not null
#
# Indexes
#
#  index_tokens_on_room_id  (room_id)
#
# Foreign Keys
#
#  fk_rails_...  (room_id => rooms.id)
#
require 'rails_helper'

RSpec.describe Token, type: :model do
  subject(:token) { create(:token) }

  let(:event) { create(:event) }
  let(:content) { create(:content) }
  let(:url) { Faker::Internet.url }
  let(:text) { Faker::Tea.variety }

  it { is_expected.to belong_to(:room) }

  describe '#create_url_hotspot' do
    subject(:create_url_hotspot) do
      token.create_url_hotspot(event: event, url: url, text: text, type: :new_page)
    end

    it 'creates url hotspot', :aggregate_failures do
      expect { create_url_hotspot }.to change(Hotspot, :count)

      hotspot = Hotspot.last
      expect(hotspot.event).to eq(event)
      expect(hotspot.external_id).to eq(token.token)
      expect(hotspot.destination_url).to eq(url)
      expect(hotspot.type).to eq('new_page')

      label = Label.last
      expect(label.external_id).to eq(token.token)
      expect(label.text).to eq(text)
    end

    it 'creates label' do
      expect { create_url_hotspot }.to change(Label, 'count').by(1)
    end

    it 'returns the hotspot' do
      expect(create_url_hotspot).to eq(Hotspot.last)
    end

    it 'sets the presign to the false state' do
      created_hotspot = create_url_hotspot
      expect(created_hotspot.presign).to be false
    end
  end

  describe '#create_label' do
    it 'creates corresponding label', :aggregate_failures do
      expect {
        token.create_label(event: event, text: text)
      }.to change(Label, :count)

      label = Label.last
      expect(label.external_id).to eq(token.token)
      expect(label.text).to eq(text)
    end
  end

  describe '#create_content_hotspot' do
    subject(:create_content_hotspot) do
      token.create_content_hotspot(event: event, content: content, text: text)
    end

    it 'creates content hotspot', :aggregate_failures do
      expect { create_content_hotspot }.to change(Hotspot, :count).by(1)

      hotspot = Hotspot.last
      expect(hotspot.event).to eq(event)
      expect(hotspot.external_id).to eq(token.token)
      expect(hotspot.destination_url).to eq(content.file.key)
      expect(hotspot.type).to eq('display')
      expect(hotspot.mime_type).to eq('application/pdf')

      label = Label.last
      expect(label.external_id).to eq(token.token)
      expect(label.text).to eq(text)

      expect(hotspot.label).to eq(label)
    end

    it 'creates label' do
      expect { create_content_hotspot }.to change(Label, 'count').by(1)
    end

    it 'returns the hotspot' do
      expect(create_content_hotspot).to eq(Hotspot.last)
    end

    it 'sets the presign to the true state' do
      created_hotspot = create_content_hotspot
      expect(created_hotspot.presign).to be true
    end
  end

  describe '#create_navigation_hotspot' do
    subject(:create_navigation_hotspot) do
      token.create_navigation_hotspot(event: event, room: room)
    end

    let(:token) { create :token, type: :navigation }
    let(:room) { create(:room) }

    it 'creates navigation hotspot', :aggregate_failures do
      expect { create_navigation_hotspot }.to change(Hotspot, 'count').by(1)

      hotspot = Hotspot.last
      expect(hotspot.external_id).to eq(token.token)
      expect(hotspot.type).to eq('navigation')
      expect(hotspot.destination_url).to eq(room.path)
    end

    it 'binds the created hotspot to the specified event' do
      create_navigation_hotspot
      expect(Hotspot.last.event).to eq(event)
    end

    it 'creates label', :aggregate_failures do
      expect { create_navigation_hotspot }.to change(Label, 'count').by(1)
      label = Label.last
      expect(label.external_id).to eq(token.token)
      expect(label.text).to eq(room.name)
    end

    it 'returns the created hotspot' do
      expect(create_navigation_hotspot).to eq(Hotspot.last)
    end
  end

  describe '#hotspot' do
    it 'returns the hotspot that attached to the specified event' do
      other_event   = create(:event)
      other_content = create(:content, name: 'other content')
      token.create_content_hotspot(event: other_event, content: other_content, text: 'tbd')
      token.create_content_hotspot(event: event, content: content, text: 'tbd')

      expected_hotspot = Hotspot.find_by!(external_id: token.token, event_id: event.id)

      expect(token.hotspot(event_id: event.id)).to eq(expected_hotspot)
    end
  end

  describe '#label' do
    it 'returns the label that attached to the specified event' do
      other_event   = create(:event)
      other_content = create(:content, name: 'other content')
      token.create_content_hotspot(event: other_event, content: other_content, text: 'tbd')
      token.create_content_hotspot(event: event, content: content, text: 'tbd')

      expected_label = Label.find_by!(external_id: token.token, event_id: event.id)

      expect(token.label(event_id: event.id)).to eq(expected_label)
    end
  end

  describe '#detach_hotspot!' do
    subject(:detach_hotspot!) do
      token.detach_hotspot!(event_id: event.id)
    end

    before do
      token.create_content_hotspot(event: event, content: content, text: '_')
    end

    it 'detaches the hotspot from the token' do
      expect { detach_hotspot! }.to \
        change { token.reload.hotspot(event_id: event.id) }.to(nil)
    end

    it 'destroyes the hotspot' do
      expect { detach_hotspot! }.to change(Hotspot, 'count').by(-1)
    end

    it 'detaches the label from the token' do
      expect { detach_hotspot! }.to \
        change { token.reload.label(event_id: event.id) }.to(nil)
    end

    it 'destroyes the label' do
      expect { detach_hotspot! }.to change(Label, 'count').by(-1)
    end

    it 'doesnt destroy the content object' do
      expect { detach_hotspot! }.not_to change(Content, 'count')
    end
  end
end
