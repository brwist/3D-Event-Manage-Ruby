class AddMymeTypeToContent < ActiveRecord::Migration[6.1]
  def change
    add_column :contents, :myme_type, :string
  end
end
