class CreateVerifications < ActiveRecord::Migration
  def change
    create_table :verifications do |t|
      t.integer :building_id
      t.integer :user_id
      t.integer :verifier_id
      t.timestamps null: false
    end
    add_foreign_key("invitations", "users")
    add_foreign_key("invitations", "buildings")
  end
end
