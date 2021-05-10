# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RedisExport::AttendanceDeleting do
  let(:event) { create :event }
  let(:attendee) { create :attendee }
  let(:attendance) { Attendance.create!(event: event, attendee: attendee) }

  # clean up redis records
  after do
    keys_to_del = $redis.keys("test.*")
    $redis.del(keys_to_del) if keys_to_del.present?
  end

  subject do
    described_class.new(event: event, attendee: attendee, attendance: attendance)
  end

  describe '#call' do
    it 'removes attendee JSON from redis' do
      redis_key = "test.attendee.#{event.client.slug}.#{event.slug}"
      $redis.hset(redis_key, attendee.email, 'some data')

      expect { subject.call }
        .to change { $redis.hget(redis_key, attendee.email) }
        .from('some data').to(nil)
    end
  end
end
