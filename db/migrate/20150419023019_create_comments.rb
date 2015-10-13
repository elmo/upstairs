class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :parent_comment_id
      t.text :body
      t.references :commentable, polymorphic: true, index: true
      t.boolean :flagged, default: false
      t.timestamps null: false
    end
    add_foreign_key('comments', 'users')
  end
end
