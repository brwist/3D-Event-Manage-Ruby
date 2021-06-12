# frozen_string_literal: true

class AddDeviseRecoverableToAttendees < ActiveRecord::Migration[6.1]
  def change
    change_table :attendees do |t|
      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
    end

    add_index :attendees, :reset_password_token, unique: true
  end
end
