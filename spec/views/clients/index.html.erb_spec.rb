# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'clients/index', type: :view do
  before do
    assign(:clients, [create(:client), create(:client)])
    assign(:page, instance_double('GearedPagination::Page', last?: true))
  end

  it 'renders a list of clients' do
    render
  end
end
