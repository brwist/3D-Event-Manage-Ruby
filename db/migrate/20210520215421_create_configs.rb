# frozen_string_literal: true

class CreateConfigs < ActiveRecord::Migration[6.1]
  def change
    create_table :configs do |t|
      t.string :name, index: { unique: true }
      t.string :value

      t.timestamps
    end
  end
end
