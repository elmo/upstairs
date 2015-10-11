class CreateVerificationRequests < ActiveRecord::Migration
  def change
    create_table :verification_requests do |t|
      t.integer :user_id
      t.integer :building_id
      t.string :status, default: 'New'
      t.timestamps null: false
    end
    add_index(:verification_requests, :building_id)
    add_index(:verification_requests, :user_id)
    add_foreign_key("verification_requests", "users")
    add_foreign_key("verification_requests", "buildings")
  end
end
