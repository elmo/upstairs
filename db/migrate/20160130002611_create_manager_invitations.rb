class CreateManagerInvitations < ActiveRecord::Migration
  def change
    create_table :manager_invitations do |t|
      t.integer :user_id
      t.string :email
      t.string :status, default: 'new'
      t.timestamps null: false
    end
  end
end
