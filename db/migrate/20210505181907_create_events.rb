class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :name
      t.string :slug
      t.datetime :start_time
      t.datetime :end_time
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
