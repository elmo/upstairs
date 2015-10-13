class CreateVerifications < ActiveRecord::Migration
  def change
    create_table :verifications do |t|
      t.integer :building_id
      t.integer :user_id
      t.integer :verifier_id
      t.integer :verification_request_id
      t.timestamps null: false
    end
    add_index(:verifications, :building_id, unique: false)
    add_index(:verifications, :user_id, unique: false)
    add_foreign_key('verifications', 'users')
    add_foreign_key('verifications', 'buildings')
  end
end
