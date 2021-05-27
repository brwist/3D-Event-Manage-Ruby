# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/hotspots', type: :request do
  let(:user) { create :user }

  before { sign_in user }

  describe 'DELETE /hotspot/:id' do
    let(:token) { create(:token) }
    let(:event) { create(:event) }
    let(:content) { create(:content) }

    before do
      token.create_content_hotspot(event: event, content: content, text: '__')
    end

    it 'responses with redirect' do
      delete hotspot_path(Hotspot.last)
      expect(response).to redirect_to(edit_event_path(event))
    end

    it 'detaches the hotspot from the token' do
      expect { delete hotspot_path(Hotspot.last) }.to \
        change { token.reload.hotspot(event_id: event.id) }.to(nil)
    end

    it 'returns the flash notification' do
      delete hotspot_path(Hotspot.last)
      expect(flash[:notice]).to include('detached')
    end
  end
end
