# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'events/show', type: :view do
  before do
    @event = assign(:event, create(:event))
    @attendees = @event.attendees
  end

  it 'renders attributes in <p>' do
    render
  end
end
