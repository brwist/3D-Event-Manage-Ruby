# frozen_string_literal: true

class DropAttendance < ActiveRecord::Migration[6.1]
  def change
    drop_table :attendances
  end
end
