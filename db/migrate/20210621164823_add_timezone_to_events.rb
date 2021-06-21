class AddTimezoneToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :timezone, :string, after: :end_time
  end
end
