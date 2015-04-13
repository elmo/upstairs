class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.string :name
      t.string :address_line_one
      t.string :address_line_two
      t.string :city
      t.string :state
      t.string :postal_code
      t.boolean :status
      t.timestamps null: false
    end
  end
end
