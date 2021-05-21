class ReorganizeContentColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :contents, :myme_type, :string
  end
end
