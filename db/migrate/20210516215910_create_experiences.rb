# frozen_string_literal: true

class CreateExperiences < ActiveRecord::Migration[6.1]
  def change
    create_table :experiences do |t|
      t.string :path

      t.timestamps
    end

    add_reference :events, :main_entrance, references: :experiences
    add_foreign_key :events, :experiences, column: :main_entrance_id
  end
end
