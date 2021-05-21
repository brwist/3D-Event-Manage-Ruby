# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  it { is_expected.to have_many(:label_tokens) }
  it { is_expected.to have_many(:hotspot_tokens) }
end
