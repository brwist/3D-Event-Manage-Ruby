class RefactorHotspotTokenLabelRelationship < ActiveRecord::Migration[6.1]
  def change
    remove_reference :hotspots, :token
    add_reference :hotspots, :label
  end
end
