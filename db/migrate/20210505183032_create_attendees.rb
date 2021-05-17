# frozen_string_literal: true

class CreateAttendees < ActiveRecord::Migration[6.1]
  def change
    create_table :attendees do |t|
      t.string :name, null: false, default: ''
      t.string :email, null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      t.timestamps
    end

    add_index :attendees, :email, unique: true
  end
end
