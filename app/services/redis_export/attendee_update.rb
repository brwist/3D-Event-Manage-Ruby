module RedisExport
  class AttendeeUpdate
    include DataHelper

    def initialize(attendee:)
      @attendee = attendee
      @events = attendee.events.includes(:client)
    end

    def call
      @events.each do |event|
        @event = event
        @client = event.client

        Redis.current.hdel(event_key, previous_email) if previous_email
        Redis.current.hset(event_key, @attendee.email, attendee_json)
      end
    end

    private

    def previous_email
      @attendee.previous_changes[:email]&.first
    end
  end
end
