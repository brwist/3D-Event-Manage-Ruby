module TimeHelper
  def pretty_time(time)
    time.in_time_zone("Eastern Time (US & Canada)").strftime('%Y, %b %d - %H:%M')
  end
end
