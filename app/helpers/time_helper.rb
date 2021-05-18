# frozen_string_literal: true

module TimeHelper
  def pretty_time(time)
    time.in_time_zone.strftime('%Y, %b %d - %H:%M (%Z)')
  end
end
