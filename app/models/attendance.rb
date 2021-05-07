class Attendance < ApplicationRecord
  belongs_to :attendee
  belongs_to :event

  after_commit :notify_observers

  validates :attendee_id, uniqueness: { scope: :event_id }

  def observers
    @observers ||=
      if Rails.application.config.cache_events_in_redis
        [ RedisExport::AttendanceObserver.new ]
      else
        []
      end
  end

  private

  def notify_observers
    observers.each do |observer|
      observer.update(self)
    end
  end
end
