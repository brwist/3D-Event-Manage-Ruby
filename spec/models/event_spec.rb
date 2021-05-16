# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  subject(:event) { create(:event) }

  it { is_expected.to(validate_presence_of(:name)) }
  it { is_expected.to(validate_presence_of(:start_time)) }
  it { is_expected.to(validate_presence_of(:end_time)) }

end
