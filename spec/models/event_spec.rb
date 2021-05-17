# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  subject(:event) { create(:event) }

  it { is_expected.to(validate_presence_of(:name)) }
  it { is_expected.to(validate_presence_of(:start_time)) }
  it { is_expected.to(validate_presence_of(:end_time)) }
  it { is_expected.to belong_to(:main_entrance).class_name('Experience') }

  describe '#publish' do
    before do
      event.publish
    end

    it 'publishes configuration' do
      expect(Redis.current.hget("configuration.#{event.key}", 'main_entrance')).to eq event.main_entrance.path
    end
  end
end
