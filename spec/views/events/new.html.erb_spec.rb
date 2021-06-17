# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'events/new', type: :view do
  let(:rooms) { create_list(:room, 2) }
  let(:clients) { create_list(:client, 2) }
  let(:content_images) { create_list(:content, 2, :with_jpeg_file) }

  before do
    assign(:rooms, rooms)
    assign(:content_images, content_images)
    assign(:clients, clients)
    assign(:event, Event.new)
  end

  it 'renders new event form' do
    render

    assert_select 'form[action=?][method=?]', events_path, 'post' do
    end
  end
end
