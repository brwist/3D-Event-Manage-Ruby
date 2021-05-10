# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RedisExport::AttendanceObserver do
  let(:event) { create :event }
  let(:attendee) { create :attendee }

  context 'attendance was created' do
    let(:created_attendance) { Attendance.create!(event: event, attendee: attendee) }

    it 'calls AttendanceCreation service object' do
      expect_any_instance_of(RedisExport::AttendanceCreation).to receive(:call)
      subject.update(created_attendance)
    end

    it "doesn't call destroy service object" do
      expect_any_instance_of(RedisExport::AttendanceDeleting).to_not receive(:call)
      subject.update(created_attendance)
    end
  end

  context 'attendance was deleted' do
    before { Attendance.create!(event: event, attendee: attendee) }

    let(:attendance) { Attendance.last }

    it 'calls AttendanceDeleting service object' do
      deleted_attendance = attendance.destroy!

      expect_any_instance_of(RedisExport::AttendanceDeleting).to receive(:call)
      subject.update(deleted_attendance)
    end

    it "doesn't call creation service object" do
      deleted_attendance = attendance.destroy!

      expect_any_instance_of(RedisExport::AttendanceCreation).to_not receive(:call)
      subject.update(deleted_attendance)
    end
  end
end
