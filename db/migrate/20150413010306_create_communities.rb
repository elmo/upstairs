class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.string :name
      t.string :address
      t.float :latitude, :float
      t.float :longitude
      t.boolean :active, default: true
      t.integer :landlord_id
      t.timestamps null: false
    end
  end
end
