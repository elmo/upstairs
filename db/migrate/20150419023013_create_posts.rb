class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.references :postable, polymorphic: true, index: true
      t.string :title
      t.text :body
      t.boolean :flagged, default: false
      t.timestamps null: false
    end
    add_index :posts, :postable_id
  end
end
