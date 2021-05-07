module RedisExport
  class BaseObserver

    private

    def created?(record)
      before, after = record.previous_changes[:id].to_a
      before.nil? and after.present?
    end
  end
end
