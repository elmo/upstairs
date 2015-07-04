class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.references :notifiable, polymorphic: true, index: true
      t.timestamps null: false
    end
    add_index :notifications, :notifiable_id
    add_foreign_key("notifications", "users")
  end
end
