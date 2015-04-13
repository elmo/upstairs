class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :community_id
      t.timestamps null: false
    end
    add_index(:memberships,[:user_id, :community_id], unique: true)
  end
end
