# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RedisExport::AttendanceObserver do
  let(:event) { create :event }
  let(:attendee) { create :attendee }

  context 'attendance was created' do
    let(:fake_exporter) { instance_double('RedisExport::AttendanceCreation') }
    let(:attendance) do
      record = Attendance.new(event: event, attendee: attendee)
      allow(record).to receive(:observers).and_return([])
      record.save!
      record
    end

    it 'calls AttendanceCreation service object' do
      expect_any_instance_of(RedisExport::AttendanceCreation).to receive(:call)
      subject.update(attendance)
    end
  end
end
