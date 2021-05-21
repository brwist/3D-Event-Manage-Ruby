# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'contents/show', type: :view do
  before do
    @content = assign(:content, Content.create!)
  end

  it 'renders attributes in <p>' do
    render
  end
end
