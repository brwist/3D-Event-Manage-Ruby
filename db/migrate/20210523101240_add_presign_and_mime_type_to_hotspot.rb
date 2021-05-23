class AddPresignAndMimeTypeToHotspot < ActiveRecord::Migration[6.1]
  def change
    add_column :hotspots, :presign, :boolean, default: false
    add_column :hotspots, :mime_type, :string
  end
end
