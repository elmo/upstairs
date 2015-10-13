class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.integer :building_id
      t.string :token
      t.string :email
      t.datetime :redeemed_at
      t.string :type
      t.timestamps null: false
    end
    add_index('invitations', 'user_id')
    add_index('invitations', 'building_id')
    add_index('invitations', 'token')
    add_foreign_key('invitations', 'users')
    add_foreign_key('invitations', 'buildings')
  end
end
