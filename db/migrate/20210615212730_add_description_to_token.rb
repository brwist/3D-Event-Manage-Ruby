class AddDescriptionToToken < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :description, :string
  end
end
