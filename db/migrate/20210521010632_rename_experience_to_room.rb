# frozen_string_literal: true

class RenameExperienceToRoom < ActiveRecord::Migration[6.1]
  def change
    rename_table :experiences, :rooms
  end
end
