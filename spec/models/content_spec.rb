# frozen_string_literal: true

# == Schema Information
#
# Table name: contents
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Content, type: :model do
  it { is_expected.to have_many(:hotspots).dependent(:destroy) }
end
