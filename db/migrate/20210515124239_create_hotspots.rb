# frozen_string_literal: true

class CreateHotspots < ActiveRecord::Migration[6.1]
  def change
    create_table :hotspots do |t|
      t.string :external_id
      t.references :event, null: false, foreign_key: true
      t.string :destination_url
      t.string :type
      t.string :tooltip

      t.timestamps
    end
  end
end
