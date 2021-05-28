class ConvertContentToTypeForToken < ActiveRecord::Migration[6.1]
  def change
    remove_column :tokens, :content, :boolean, default: false
    add_column :tokens, :type, :string, default: 'content'
  end
end
