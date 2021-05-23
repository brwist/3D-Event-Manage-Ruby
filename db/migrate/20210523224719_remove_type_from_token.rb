class RemoveTypeFromToken < ActiveRecord::Migration[6.1]
  class HotspotToken < Token; end
  class LabelToken < Token; end

  def change
    HotspotToken.all.each do |token|
      token.update!(content: true)
      LabelToken.where(token: token.token).destroy_all
    end
    remove_column :tokens, :type, :string
  end
end
