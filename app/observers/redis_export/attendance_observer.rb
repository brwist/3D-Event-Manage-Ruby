module RedisExport
  class AttendanceObserver < BaseObserver
    def update(attendance)
      case
      when created?(attendance) then store_in_redis!(attendance)
      end
    end

    private

    def store_in_redis!(attendance)
      AttendanceCreation.new(attendance: attendance).call
    end
  end
end
