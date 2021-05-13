module RedisExport
  class AttendanceDeleting
    include DataHelper

    def initialize(attendance:, event: nil, client: nil, attendee: nil)
      @attendance = attendance
      @event = event || attendance.event
      @attendee = attendee || attendance.attendee
      @client = client || @event.client
    end

    def call
      Redis.current.hdel(event_key, @attendee.email)
    end
  end
end
