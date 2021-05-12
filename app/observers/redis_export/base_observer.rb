module RedisExport
  class BaseObserver

    private

    def created?(record)
      before, after = record.previous_changes[:id].to_a
      before.nil? and after.present?
    end

    def updated?(record)
      changes = record.previous_changes
      changes.present? && changes[:id].blank? && !record.destroyed?
    end
  end
end
