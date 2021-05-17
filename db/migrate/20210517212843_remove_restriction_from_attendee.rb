class RemoveRestrictionFromAttendee < ActiveRecord::Migration[6.1]
  def change
    remove_index :attendees, column: [:email], unique: true
    add_index :attendees, [:email, :event_id], unique: true
  end
end
