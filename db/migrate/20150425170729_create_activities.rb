class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.integer :building_id
      t.references :actionable, polymorphic: true, index: true, dependent: :destroy
      t.timestamps null: false
    end
    add_index :activities, :actionable_id
    add_index :activities, :user_id
    add_index :activities, :building_id
    add_foreign_key("activities", "users")
    add_foreign_key("activities", "buildings")
  end
end
