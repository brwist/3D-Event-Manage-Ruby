# frozen_string_literal: true

class CreateContents < ActiveRecord::Migration[6.1]
  def change
    create_table :contents do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
