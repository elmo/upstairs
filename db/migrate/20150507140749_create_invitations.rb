class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.integer :community_id
      t.string :token
      t.string :email
      t.datetime :redeemed_at
      t.string :type
      t.timestamps null: false
    end
    add_column :users, :invitation_id, :integer
  end
end
