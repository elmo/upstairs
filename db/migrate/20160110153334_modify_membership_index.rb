class ModifyMembershipIndex < ActiveRecord::Migration
  def change
    remove_index(:memberships, [:user_id, :building_id] )
    add_index(:memberships, [:user_id, :building_id, :membership_type], unique: true, name: 'user_buidling_membership')
  end
end
