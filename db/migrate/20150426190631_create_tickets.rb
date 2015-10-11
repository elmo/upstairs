class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :user_id
      t.integer :building_id
      t.string :title
      t.text :body
      t.string :severity
      t.string :status
      t.timestamps null: false
    end
    add_index :tickets, [:building_id, :severity], unique: false
    add_index :tickets, [:building_id, :status], unique: false
    add_foreign_key('tickets', 'users')
    add_foreign_key('tickets', 'buildings')
  end
end
