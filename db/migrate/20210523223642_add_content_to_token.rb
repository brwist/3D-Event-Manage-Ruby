class AddContentToToken < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :content, :boolean, default: false
  end
end
