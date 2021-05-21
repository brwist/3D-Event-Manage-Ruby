# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'contents/edit', type: :view do
  let(:content) { Content.create!(name: Faker::FunnyName.name) }

  before do
    assign(:content, content)
  end

  it 'renders the edit content form' do
    render

    assert_select 'form[action=?][method=?]', content_path(content), 'post' do
    end
  end
end
