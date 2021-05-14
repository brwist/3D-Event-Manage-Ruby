class Attendee < ApplicationRecord
  devise :database_authenticatable

  has_many :attendances
  has_many :events, through: :attendances, dependent: :destroy

  after_commit :notify_observers

  validates :name, :email, presence: true

  def observers
    @observers ||=
      if Rails.application.config.cache_events_in_redis
        [ RedisExport::AttendeeObserver.new ]
      else
        []
      end
  end

  private

  def notify_observers
    observers.each { |observer| observer.update(self) }
  end

end
