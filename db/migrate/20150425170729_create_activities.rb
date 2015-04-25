class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.integer :community_id
      t.references :actionable, polymorphic: true, index: true, dependent: :destroy
      t.timestamps null: false
    end
    add_index :activities, :actionable_id
    add_index :activities, :user_id
    add_index :activities, :community_id
  end
end
