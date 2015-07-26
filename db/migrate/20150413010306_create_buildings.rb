class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.string :name
      t.string :address
      t.string :invitation_link
      t.float :latitude, :float
      t.float :longitude
      t.boolean :active, default: true
      t.timestamps null: false
    end
    add_index(:buildings, :address, unique: true)
  end
end
