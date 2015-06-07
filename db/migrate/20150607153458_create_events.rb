class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :body
      t.datetime :starts
      t.integer :community_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
