# frozen_string_literal: true

class CreateTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :tokens do |t|
      t.string :type, null: false, default: 'HotspotToken'
      t.string :name, null: false
      t.string :token, null: false
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
