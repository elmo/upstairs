class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :user_id
      t.integer :community_id
      t.string :message
      t.timestamps null: false
    end
  end
end
