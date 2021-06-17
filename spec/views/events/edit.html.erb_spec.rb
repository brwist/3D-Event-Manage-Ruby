# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'events/edit', type: :view do
  let(:event) { create(:event) }
  let(:rooms) { create_list(:room, 2) }
  let(:clients) { create_list(:client, 2) }
  let(:content_images) { create_list(:content, 2, :with_jpeg_file) }

  before do
    assign(:content_images, content_images)
    assign(:clients, clients)
    assign(:rooms, rooms)
    assign(:event, event)
    assign(:attendees, event.attendees)
  end

  it 'renders the edit event form' do
    render

    assert_select 'form[action=?][method=?]', event_path(Event.last), 'post' do
    end
  end
end
