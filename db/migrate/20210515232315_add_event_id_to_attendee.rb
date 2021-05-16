class AddEventIdToAttendee < ActiveRecord::Migration[6.1]
  def change
    add_reference :attendees, :event, null: false, foreign_key: true
  end
end
