class RemoveUnusedColumns < ActiveRecord::Migration
  def change
    remove_column :posts, :posts
  end
end
