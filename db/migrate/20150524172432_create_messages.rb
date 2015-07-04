class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.integer :building_id
      t.text :body
      t.boolean :read, default: false
      t.timestamps null: false
      t.string :slug
    end
    add_index(:messages, [:building_id,:sender_id] )
    add_index(:messages, [:building_id,:recipient_id] )
    add_index(:messages, :slug)
  end
end
