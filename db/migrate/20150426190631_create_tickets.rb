class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :user_id
      t.integer :community_id
      t.string :title
      t.text :body
      t.string :severity
      t.string :status
      t.timestamps null: false
    end

    add_index :tickets, [:community_id, :severity], unique: false
  end
end