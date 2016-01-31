class AddInvitationTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :invitation_type, :string
  end
end
