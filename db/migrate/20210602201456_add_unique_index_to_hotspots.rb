class AddUniqueIndexToHotspots < ActiveRecord::Migration[6.1]
  def change
    add_index :hotspots, [:event_id, :external_id], unique: true
  end
end
