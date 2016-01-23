class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.integer :building_id
      t.string :name
      t.integer :user_id
      t.timestamps null: false
    end
    add_index(:units, :building_id, unique: false)
  end
end
