class ModifyMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :membership_type, :string, default: 'Guest'
    add_index(:memberships, [:membership_type, :building_id, :user_id], unique: true, name: 'user_building_membership')
  end
end
