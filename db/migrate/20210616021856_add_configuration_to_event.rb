class AddConfigurationToEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :landing_prompt, :string
    add_column :events, :landing_logo, :string
    add_column :events, :landing_background_color, :string
    add_column :events, :landing_foreground_color, :string
  end
end
