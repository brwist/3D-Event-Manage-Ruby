# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RedisExport::AttendanceCreation do
  let(:event) { create :event }
  let(:attendee) { create :attendee }
  let(:attendance) { Attendance.create!(event: event, attendee: attendee) }

  after do
    keys_to_del = $redis.keys("test.*")
    $redis.del(keys_to_del) if keys_to_del.present?
  end

  subject do
    described_class.new(event: event, attendee: attendee, attendance: attendance)
  end

  describe "#call" do
    let(:fake_json) { 'fake json' }

    it 'adds attendee JSON to redis' do
      allow(subject).to receive(:attendee_json).and_return(fake_json)

      expect { subject.call }
        .to change { $redis.hget("test.attendee.#{event.client.slug}.#{event.slug}", attendee.email) }
        .from(nil).to(fake_json)
    end
  end

  describe "#attendee_json" do
    it 'contains correct data' do
      exporter = described_class.new(event: event, attendee: attendee, attendance: attendance)
      expect(Oj.load(exporter.attendee_json)).to eq(
        'client' => event.client.name,
        'event'  => event.name,
        'name'   => attendee.name,
        'email'  => attendee.email,
        'encrypted_password' => attendee.encrypted_password
      )
    end
  end
end
