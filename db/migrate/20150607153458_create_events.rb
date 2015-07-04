class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :body
      t.datetime :starts
      t.integer :building_id
      t.integer :user_id
      t.timestamps null: false
    end
    add_index(:events, :building_id)
    add_index(:events, :user_id)
    add_foreign_key("events", "users")
    add_foreign_key("events", "buildings")
  end
end
