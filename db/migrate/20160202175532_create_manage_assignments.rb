class CreateManageAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :user_id
      t.integer :assigned_to
      t.integer :ticket_id
      t.datetime :accepted_at
      t.datetime :completed_at

      t.timestamps null: false
    end
  end
end
