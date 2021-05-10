module RedisExport
  class AttendanceObserver < BaseObserver
    def update(attendance)
      case
      when created?(attendance)
        AttendanceCreation.new(attendance: attendance).call
      end
    end
  end
end
