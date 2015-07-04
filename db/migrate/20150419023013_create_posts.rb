class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :category_id
      t.references :postable, polymorphic: true, index: true
      t.string :title
      t.string :posts, :slug, :string
      t.text :body
      t.boolean :flagged, default: false
      t.timestamps null: false
    end
    add_index :posts, :postable_id
    add_index :posts, :slug, unique: false
    add_foreign_key("posts", "users")
  end
end
