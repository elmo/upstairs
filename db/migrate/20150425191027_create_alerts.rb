class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :user_id
      t.integer :building_id
      t.string :message
      t.timestamps null: false
    end
    add_index(:alerts, :user_id)
    add_index(:alerts, :building_id)
    add_foreign_key("alerts", "users")
    add_foreign_key("alerts", "buildings")
  end
end
