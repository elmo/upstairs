class CreateClassifieds < ActiveRecord::Migration
  def change
    create_table :classifieds do |t|
      t.integer :user_id
      t.integer :community_id
      t.integer :category_id
      t.string :title
      t.text :body
      t.timestamps null: false
    end
  end
end
