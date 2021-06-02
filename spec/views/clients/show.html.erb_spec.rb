# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'clients/show', type: :view do
  before do
    assign(:client, create(:client))
  end

  it 'renders attributes in <p>' do
    render
  end
end
