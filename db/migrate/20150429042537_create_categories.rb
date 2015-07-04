class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :parent_category_id
      t.timestamps null: false
    end
     add_foreign_key("posts", "categories")
  end
end
