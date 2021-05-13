module TimeHelper
  def pretty_time(time)
    time.in_time_zone.strftime('%Y, %b %d - %H:%M')
  end
end
