# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[6.1]
  def change
    create_table :clients do |t|
      t.string :name, null: false, default: ''
      t.string :slug, null: false

      t.timestamps
    end
    add_index :clients, :slug, unique: true
  end
end
