class AddUniqeIndexToLabels < ActiveRecord::Migration[6.1]
  def change
    add_index :labels, [:event_id, :external_id], unique: true
  end
end
