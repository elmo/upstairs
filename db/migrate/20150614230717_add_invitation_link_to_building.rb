class AddInvitationLinkToBuilding < ActiveRecord::Migration
  def change
    add_column :buildings, :invitation_link, :string
  end
end
