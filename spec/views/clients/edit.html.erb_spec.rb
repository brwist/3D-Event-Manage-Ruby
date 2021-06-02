# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'clients/edit', type: :view do
  let(:client) { create :client }

  before do
    assign(:client, client)
  end

  it 'renders the edit client form' do
    render

    assert_select 'form[action=?][method=?]', client_path(client), 'post' do
    end
  end
end
