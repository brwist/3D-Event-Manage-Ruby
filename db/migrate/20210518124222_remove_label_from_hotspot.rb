# frozen_string_literal: true

class RemoveLabelFromHotspot < ActiveRecord::Migration[6.1]
  def change
    remove_column :hotspots, :tooltip, :string
  end
end
