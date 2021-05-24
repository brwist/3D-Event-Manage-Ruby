class AddTokenReferenceToLabel < ActiveRecord::Migration[6.1]
  def change
    add_reference :labels, :token, foreign_key: true
  end
end
