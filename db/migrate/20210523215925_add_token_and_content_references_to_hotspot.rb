class AddTokenAndContentReferencesToHotspot < ActiveRecord::Migration[6.1]
  def change
    add_reference :hotspots, :token, foreign_key: true
    add_reference :hotspots, :content, foreign_key: true
  end
end
