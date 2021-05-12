# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RedisExport::AttendeeObserver do
  context 'attendee created' do
    it "doesn't call AttendeeUpdate service object" do
      expect_any_instance_of(RedisExport::AttendeeUpdate).to_not receive(:call)
      subject.update(create(:attendee))
    end
  end

  context 'attendee updated' do
    it "calls AttendeeUpdate service object" do
      attendee = create(:attendee).reload
      attendee.update!(email: 'hr@slimeshop.com')

      expect_any_instance_of(RedisExport::AttendeeUpdate).to receive(:call)
      subject.update(attendee)
    end
  end

  context 'attendee destroyed' do
    it "doesn't call AttendeeUpdate service object" do
      destroyed_attendee = create(:attendee).reload.destroy

      expect_any_instance_of(RedisExport::AttendeeUpdate).to_not receive(:call)
      subject.update(destroyed_attendee)
    end
  end
end
