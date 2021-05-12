module RedisExport
  class AttendeeObserver < BaseObserver
    def update(attendee)
      if updated?(attendee)
        RedisExport::AttendeeUpdate.new(attendee: attendee).call
      end
    end
  end
end
