class AddInvitedToBuildingIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :invited_to_building_id, :integer
  end
end
