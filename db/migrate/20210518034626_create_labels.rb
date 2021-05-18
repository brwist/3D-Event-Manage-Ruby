# frozen_string_literal: true

class CreateLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :labels do |t|
      t.string :external_id
      t.references :event, null: false, foreign_key: true
      t.string :text

      t.timestamps
    end
  end
end
