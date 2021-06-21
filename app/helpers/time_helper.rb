# frozen_string_literal: true

module TimeHelper
  def pretty_time(time)
    time.in_time_zone.strftime('%b %d - %H:%M')
  end
end
