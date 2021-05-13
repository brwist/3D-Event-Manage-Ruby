module RedisExport
  class AttendanceCreation
    include DataHelper

    def initialize(attendance:, event: nil, client: nil, attendee: nil)
      @attendance = attendance
      @event = event || attendance.event
      @attendee = attendee || attendance.attendee
      @client = client || @event.client
    end

    def call
      Redis.current.hset(event_key, @attendee.email, attendee_json)
    end
  end
end
