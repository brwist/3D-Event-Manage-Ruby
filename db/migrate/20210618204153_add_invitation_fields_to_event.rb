class AddInvitationFieldsToEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :send_invitation_at, :datetime
    add_column :events, :invitation_scheduled, :boolean, default: false
    add_column :events, :invitation_sent, :boolean, default: false
  end
end
