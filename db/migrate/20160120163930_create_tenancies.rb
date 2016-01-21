class CreateTenancies < ActiveRecord::Migration
  def change
    create_table :tenancies do |t|
      t.integer :unit_id
      t.integer :user_id
      t.integer :building_id
      t.timestamps null: false
    end
  end
end
