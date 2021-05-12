# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RedisExport::AttendeeUpdate do
  include RedisHelper

  let(:client) { create :client }
  let(:event_one) { create :event, client: client }
  let(:event_two) { create :event, client: client, name: "Medusa party" }
  let(:attendee)  { create :attendee, name: 'John Lakeman', email: 'mr_mudd@cia.gov', password: '12345678' }

  before { clean_up_redis_tests }

  describe '#call' do
    before do
      # create attendances and store records in Redis
      [event_one, event_two].each do |event|
        attendance = event.attendances.build(attendee: attendee)
        attendance.observers << RedisExport::AttendanceObserver.new
        attendance.save!
      end
    end

    context 'attendee email not changed' do
      it 'updates the json', :aggregate_failures do
        attendee.update!(name: "Steve Conrad", password: '123456')
        old_data = attendee_redis_data(event: event_one, attendee: attendee)

        described_class.new(attendee: attendee).call
        new_data = attendee_redis_data(event: event_one, attendee: attendee)

        expect(new_data['name']).to_not eq(old_data['name'])
        expect(new_data['encrypted_password']).to_not eq(old_data['encrypted_password'])
      end
    end

    context 'attendee email changed' do
      it 'deletes old attendance records from Redis' do
        old_email = attendee.email
        attendee.update!(email: 'john@tavner.com', name: 'John Tavner')

        expect { described_class.new(attendee: attendee).call }
          .to change {
            [
              attendee_redis_data(event: event_one, email: old_email),
              attendee_redis_data(event: event_two, email: old_email)
            ]
          }
          .from([a_kind_of(Hash), a_kind_of(Hash)])
          .to([nil, nil])
      end

      it 'creates new records under new keys' do
        attendee.update!(email: 'john@tavner.com', name: 'John Tavner')

        expect { described_class.new(attendee: attendee).call }
          .to change {
            [
              attendee_redis_data(event: event_one, attendee: attendee),
              attendee_redis_data(event: event_two, attendee: attendee)
            ]
          }
          .from([nil, nil])
          .to([a_kind_of(Hash), a_kind_of(Hash)])
      end
    end
  end
end
