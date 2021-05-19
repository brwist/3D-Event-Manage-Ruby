# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'events/edit', type: :view do
  before do
    event = assign(:event, create(:event))
    assign(:attendees, event.attendees)
  end

  it 'renders the edit event form' do
    render

    assert_select 'form[action=?][method=?]', event_path(Event.last), 'post' do
    end
  end
end
