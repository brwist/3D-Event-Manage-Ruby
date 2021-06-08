# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/hotspots', type: :request do
  let(:admin) { create :user, :admin }
  let(:room) { create :room }

  before { sign_in admin }

  describe 'POST /hotspots' do
    subject(:send_request) do
      post hotspots_path(format: :js), params: { hotspot: hotspot_params }
    end

    let(:token) { create(:token, type: :navigation) }
    let(:event) { create(:event) }
    let(:room) { create(:room) }

    let(:hotspot_params) {
      {
        event_id: event.id,
        token_id: token.id,
        type: 'navigation',
        room_id: room.id
      }
    }

    it_behaves_like 'authorization protected action'

    context 'attach navigation to "empty" token' do
      it 'creates new navigation hotspot' do
        expect { send_request }.to change { Hotspot.navigation.count }.by(1)
      end

      it 'sends the notification' do
        send_request
        expect(flash[:notice]).to include('Navigation updated')
      end
    end

    context 'change the room for the token' do
      before do
        token.create_navigation_hotspot(event: event, room: room)
      end

      it 'deletes the existing hotspot and label', :aggregate_failures do
        expect(existing_hotspot = Hotspot.navigation.last).not_to be_nil
        expect(existing_label = Label.last).not_to be_nil

        send_request

        expect(Hotspot.find_by(id: existing_hotspot.id)).to be_nil
        expect(Label.find_by(id: existing_label.id)).to be_nil
      end

      it 'creates new hotspot' do
        current_hotspot = Hotspot.last

        expect { send_request }.to \
          change { token.reload.hotspot(event_id: event.id) }
          .from(current_hotspot)
          .to(instance_of(Hotspot))
      end

      it 'creates new label' do
        current_label = Label.last

        expect { send_request }.to \
          change { token.reload.label(event_id: event.id) }
          .from(current_label)
          .to(instance_of(Label))
      end

      it 'sends the notification' do
        send_request
        expect(flash[:notice]).to include('Navigation updated')
      end
    end

    context 'clear the token (select the blank option)' do
      let(:hotspot_params) {
        {
          event_id: event.id,
          token_id: token.id,
          type: 'navigation',
          room_id: room.id
        }
      }

      before do
        token.create_navigation_hotspot(event: event, room: room)
      end

      it 'deletes the existing hotspot and label', :aggregate_failures do
        expect(existing_hotspot = Hotspot.navigation.last).not_to be_nil
        expect(existing_label = Label.last).not_to be_nil

        send_request

        expect(Hotspot.find_by(id: existing_hotspot.id)).to be_nil
        expect(Label.find_by(id: existing_label.id)).to be_nil
      end

      it "doesn't attach new hotspot and label to the token" do
        expect { send_request }.not_to change(Hotspot, :count)
      end

      it 'sends the notification' do
        send_request
        expect(flash[:notice]).to include('Navigation updated')
      end
    end
  end

  describe 'DELETE /hotspot/:id' do
    let(:token) { create(:token) }
    let(:event) { create(:event) }
    let(:content) { create(:content) }

    let!(:hotspot) do
      token.create_content_hotspot(event: event, content: content, text: '__')
    end

    it_behaves_like 'authorization protected action' do
      subject(:send_request) { delete hotspot_path(hotspot) }
    end

    it 'responses with redirect' do
      delete hotspot_path(hotspot)
      expect(response).to redirect_to(edit_event_path(event, tab: 'rooms'))
    end

    it 'detaches the hotspot from the token' do
      expect { delete hotspot_path(hotspot) }.to \
        change { token.reload.hotspot(event_id: event.id) }.to(nil)
    end

    it 'returns the flash notification' do
      delete hotspot_path(hotspot)
      expect(flash[:notice]).to include('detached')
    end
  end
end
